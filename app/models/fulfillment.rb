class Fulfillment < ActiveRecord::Base
  after_create :create_linked_resources

  include AASM

  # State machine settings
  enum fulfillment_state: [ :pending, :fulfilled ]

  aasm :fulfillment, :column => :fulfillment_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :fulfilled

    event :mark_fulfilled do
      transitions :from => :pending, :to => :fulfilled
    end
  end

  belongs_to :route_visit
  belongs_to :order
  belongs_to :stock
  belongs_to :pod
  belongs_to :credit_note

  has_one :visit_window, through: :route_visit
  has_one :location, through: :visit_window
  has_one :company, through: :location
  has_one :price_tier, through: :company
  has_many :item_desires, through: :location
  has_many :item_prices, through: :price_tier
  has_many :item_credit_rates, through: :location

  private
  def create_linked_resources
    binding.pry
    build_stock
    build_credit_note
    build_pod

    save
  end

  def build_stock
    if stock.nil?
      self.stock = Stock.create(location:location)
      item_desires
        .select {|item_desire| item_desire.enabled}
        .each do |item_desire|
          StockLevel.create(
            item:item_desire.item,
            stock:self.stock)
          end
    end
  end

  def build_credit_note
    if credit_note.nil?
      self.credit_note = CreditNote.create(location:location, date:order.delivery_date)
      item_desires
        .select {|item_desire| item_desire.enabled}
        .each do |item_desire|
          credit_rate = Maybe(item_credit_rates.where(item:item_desire.item).first)[:rate].fetch(0.5)
          price = Maybe(item_prices.where(item:item_desire.item).first)[:price].fetch(0.0)
          CreditNoteItem.create(
            item:item_desire.item,
            unit_price:price * credit_rate,
            credit_note:self.credit_note)
        end
    end
  end

  def build_pod
    if pod.nil?
      self.pod = Pod.create
    end
  end
end
