class Order < ActiveRecord::Base
  include AASM
  include StringUtils

  SALES_ORDER_TYPE = 'sales-order'
  PURCHASE_ORDER_TYPE = 'purchase-order'

  before_save :pre_process_saving_data
  after_save :update_fulfillment_structure

  aasm :order, :column => :xero_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :submitted
    state :synced
    state :voided

    event :mark_submitted do
      transitions :from => [:pending, :synced], :to => :submitted
    end

    event :mark_synced do
      transitions :from => [:synced, :submitted], :to => :synced
    end

    # TODO: Is there a way to trap in voided once void state is set?
    # Since we allow direct set, the client may be able to get a model
    # out of voided by resubmitting
    event :void do
      transitions :from => [:pending, :submitted, :synced, :voided], :to => :voided
    end
  end

  aasm :order_state, :column => :order_state, :skip_validation_on_save => true do
    state :draft, :initial => true
    state :approved

    event :mark_draft do
      transitions :from => [:approved, :draft], :to => :draft
    end

    event :mark_approved do
      transitions :from => [:approved, :draft], :to => :approved
    end
  end

  # State machine settings
  enum order_state: [ :draft, :approved ]
  enum xero_state: [ :pending, :submitted, :synced, :voided ]

  belongs_to :location
  has_one :address, through: :location
  has_one :fulfillment, dependent: :destroy, autosave: true
  has_one :route_visit, through: :fulfillment
  has_many :order_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
  has_many :notifications, dependent: :nullify, autosave: true

  scope :purchase_order, -> { where(order_type:PURCHASE_ORDER_TYPE)}
  scope :sales_order, -> { where(order_type:SALES_ORDER_TYPE)}
  scope :has_active_location, -> { joins(:location).where(locations: {active: true}) }

  def has_synced_with_xero?
    xero_id.present?
  end

  def has_processed_notification?
    notifications.processed.present?
  end

  def has_pending_notification?
    notifications.pending.present?
  end

  def never_notified?
    notifications.empty?
  end

  def clone(to_date: nil)
    raise "Must specify a to date" if to_date.nil?

    cloned_order = Order.create(location:location, delivery_date:to_date, order_type:order_type)
    order_items.each { |oi| oi.clone(order:cloned_order) }

    return cloned_order
  end

  def quantity_of_item(item)
    Maybe(order_items.find_by(item:item)).quantity.fetch(0)
  end

  def renderer
    sales_order? ? Pdf::Invoice : Pdf::PurchaseOrder
  end

  def sales_order?
    order_type == SALES_ORDER_TYPE
  end

  def purchase_order?
    !sales_order?
  end

  def has_quantity?
    order_items.any?(&:has_quantity?)
  end

  def is_valid?
    has_quantity?
  end

  def has_shipping?
    shipping > 0
  end

  def total
    order_items_total = order_items.inject(0) {|acc, cur| acc + cur.total }
    order_items_total + shipping
  end

  def due_date
    delivery_date + location.company.terms
  end

  def to_string
    "#{location.company.name} - #{location.code} - #{location.name}"
  end

  private
  def pre_process_saving_data
    # Generate order number
    self.order_number = trim_and_downcase order_number
    generate_order_number unless valid_order_number?

    set_default_shipping unless shipping.present?
  end

  def generate_order_number
    prefix = sales_order? ? 'SO' : 'PO'
    self.order_number = "#{prefix}-#{delivery_date.strftime('%y%m%d')}-#{SecureRandom.hex(2)}".downcase

    generate_order_number unless valid_order_number?
  end

  def valid_order_number?
    match = Order.find_by(order_number: order_number)
    (match.nil? || match == self) && order_number.present?
  end

  def set_default_shipping
    self.shipping = location.delivery_rate
  end

  def stale_route_visit?
    Maybe(fulfillment).route_visit.date.fetch(nil) != delivery_date
  end

  def update_fulfillment_structure
    if Maybe(fulfillment).route_visit.present?
      if stale_route_visit?
        fulfillment.route_visit = generate_parent_route_visit
        fulfillment.save
      end
    else
      create_fulfillment_structure
    end
  end

  def generate_parent_route_visit
    RouteVisit.find_or_create_by(date:delivery_date, address:address)
  end

  def create_fulfillment_structure
    credit_note = CreditNote.create(date:delivery_date, location:location)
    stock = Stock.create(location:location)
    pod = Pod.create
    fulfillment = Fulfillment.create(
      route_visit:generate_parent_route_visit,
      order:self,
      pod:pod,
      credit_note: credit_note,
      stock: stock
    )
  end
end
