class Order < ActiveRecord::Base
  include AASM

  after_create :generate_order_number
  after_save :update_fulfillment_structure

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
  has_one :fulfillment, dependent: :nullify, autosave: true
  has_one :route_visit, through: :fulfillment
  has_many :order_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true

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
    self.order_number = "OR-#{delivery_date.strftime('%y%m%d')}-#{SecureRandom.hex(5)}"
    save
  end

  def stale_route_visit?
    if route_visit.present?
      if route_visit.date != delivery_date
        true
      else
        false
      end
    else
      false
    end
  end

  def update_fulfillment_structure
    if route_visit.present?
      if stale_route_visit?
        fulfillment.route_visit = find_or_create_by(date:delivery_date, address:address)
        fulfillment.save
        # save
      end
    else
      create_fulfillment_structure
    end
  end

  def create_fulfillment_structure
    new_route_visit = RouteVisit.find_or_create_by(date:delivery_date, address:address)
    fulfillment = Fulfillment.create(route_visit:new_route_visit, order:self)
    fulfillment.save
    # self.update_columns(fulfillment_id:fulfillment.id)
    # save
  end

end
