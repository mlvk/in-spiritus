class Order < ActiveRecord::Base
  include StringUtils
  include SyncableModel
  include PublishableModel
  include XeroRecord
  include XeroFinancialRecordModel

  SALES_ORDER_TYPE = 'sales-order'
  PURCHASE_ORDER_TYPE = 'purchase-order'

  VALID_STATES = [0, 1, 2, 3, 4]

  before_save :pre_process_saving_data
  after_save :update_fulfillment_structure
  after_destroy :handle_empty_route_visit

  belongs_to :location
  has_one :address, through: :location
  has_one :fulfillment, dependent: :destroy, autosave: true
  has_one :route_visit, through: :fulfillment
  has_many :order_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
  has_many :notifications, dependent: :nullify, autosave: true

  scope :purchase_order, -> { where(order_type:PURCHASE_ORDER_TYPE)}
  scope :sales_order, -> { where(order_type:SALES_ORDER_TYPE)}
  scope :has_active_location, -> { joins(:location).where(locations: {active: true}) }

  # @TODO Refactor to just use synced?
  def has_synced_with_xero?
    synced?
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
    has_quantity? && valid_state?
  end

  def has_shipping?
    shipping > 0
  end

  def total_sale
    order_items.inject(0) {|acc, cur| acc + cur.total }
  end

  def total
    total_sale + shipping
  end

  def due_date
    delivery_date + location.company.terms
  end

  def to_string
    "#{location.company.name} - #{location.code} - #{location.name}"
  end

  private
  def pre_process_saving_data
    self.order_number = trim_and_downcase order_number
    generate_order_number unless valid_order_number?

    set_default_shipping unless shipping.present?
  end

  def generate_order_number
    prefix = sales_order? ? 'so' : 'po'
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
    match = RouteVisit
      .joins(:address)
      .where("lat = ?", address.lat)
      .where("lng = ?", address.lng)
      .where("date = ?", delivery_date)
      .first

    if match.nil?
      match = RouteVisit.create(date:delivery_date, address:address)
    end

    return match
  end

  def create_fulfillment_structure
    pod = Pod.create

    if sales_order?
      credit_note = CreditNote.create(date:delivery_date, location:location)
      stock = Stock.create(location:location)

      fulfillment = Fulfillment.create(
        route_visit:generate_parent_route_visit,
        order:self,
        pod:pod,
        credit_note: credit_note,
        stock: stock
      )
    else
      fulfillment = Fulfillment.create(
        route_visit:generate_parent_route_visit,
        order:self,
        pod:pod
      )
    end

  end

  def handle_empty_route_visit
    fulfillment.route_visit.destroy if !fulfillment.route_visit.has_fulfillments?
  end
end
