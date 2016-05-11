class Order < ActiveRecord::Base
  include AASM

  SALES_ORDER_TYPE = 'sales-order'
  PURCHASE_ORDER_TYPE = 'purchase-order'

  after_create :generate_order_number
  after_save :update_fulfillment_structure
  before_destroy :clear_fulfillment_structure

  aasm :order, :column => :xero_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :submitted
    state :synced
    state :voided

    event :mark_submitted do
      transitions :from => :pending, :to => :submitted
      transitions :from => :synced, :to => :submitted
    end

    event :mark_synced do
      transitions :from => :synced, :to => :synced
      transitions :from => :submitted, :to => :synced
    end

    # TODO: Is there a way to trap in voided once void state is set?
    # Since we allow direct set, the client may be able to get a model
    # out of voided by resubmitting
    event :void do
      transitions :from => [:pending, :submitted, :synced], :to => :voided
    end
  end

  # State machine settings
  enum xero_state: [ :pending, :submitted, :synced, :voided ]

  belongs_to :location
  has_one :address, through: :location
  has_one :fulfillment
  has_one :route_visit, through: :fulfillment
  has_many :order_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true

  def is_sales_order?
    order_type == SALES_ORDER_TYPE
  end

  def is_purchase_order?
    !is_sales_order?
  end

  def fulfillment_id=(_value)
     # TODO: Remove once it's fixed
  end

  def fulfillment_id
    fulfillment.id
  end

  def total
    order_items.inject(0) {|acc, cur| acc = acc + cur.total }
  end

  def due_date
    delivery_date + location.company.terms
  end

  private
  def generate_order_number
    prefix = is_sales_order? ? 'SO' : 'PO'
    self.order_number = "#{prefix}-#{delivery_date.strftime('%y%m%d')}-#{SecureRandom.hex(2)}"
    save
  end

  def stale_route_visit?
    if Maybe(fulfillment).route_visit.present?
      if fulfillment.route_visit.date != delivery_date
        true
      else
        false
      end
    else
      false
    end
  end

  def update_fulfillment_structure
    if Maybe(fulfillment).route_visit.present?
      if stale_route_visit?
        fulfillment.route_visit = RouteVisit.find_or_create_by(date:delivery_date, address:address)
        fulfillment.save
      end
    else
      create_fulfillment_structure
    end
  end

  def create_fulfillment_structure
    new_route_visit = RouteVisit.find_or_create_by(date:delivery_date, address:address)
    credit_note = CreditNote.create(date:delivery_date, location:location)
    stock = Stock.create(location:location)
    pod = Pod.create
    fulfillment = Fulfillment.create(
      route_visit:new_route_visit,
      order:self,
      pod:pod,
      credit_note: credit_note,
      stock: stock
    )
  end

  def clear_fulfillment_structure
    single_fulfillment_for_route_visit = Maybe(fulfillment).route_visit.fulfillments.size.fetch(1) == 1

    Maybe(fulfillment).route_visit.fetch.destroy if single_fulfillment_for_route_visit
    Maybe(fulfillment).fetch.destroy
  end

end
