class Company < ActiveRecord::Base
  include AASM

  before_save :pre_process_location_code_prefix

  aasm :company, :column => :xero_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :synced

    event :mark_pending do
      transitions :from => :pending, :to => :pending
      transitions :from => :synced, :to => :pending
    end

    event :mark_synced do
      transitions :from => :pending, :to => :synced
      transitions :from => :synced, :to => :synced
    end
  end

  # State machine
  enum xero_state: [ :pending, :synced ]

  validates :name, uniqueness: { case_sensitive: false }

  has_many :locations, :dependent => :destroy, autosave: true

  belongs_to :price_tier

  has_many :items

  has_many :item_prices, through: :price_tier

	def price_for_item (item)
		match = item_prices
			.where(item:item)
			.first

		match.present? ? match.price : 0.0
	end

  def initials
    name.split.map(&:first).join.downcase
  end

  def short_code
    initials.size > 1 ? initials : name[0..1]
  end

  scope :customer, -> { where(is_customer: true) }
  scope :vendor, -> { where(is_vendor: true) }

  private
  def pre_process_location_code_prefix
    generate_prefix unless has_location_code_prefix?
    self.location_code_prefix = self.location_code_prefix.downcase
  end

  def has_location_code_prefix?
    location_code_prefix.present?
  end

  def valid_prefix?(prefix)
    match = Company.find_by(location_code_prefix: prefix)
    (match.nil? || match == self) && prefix.present?
  end

  def generate_prefix(rand = false)
    prefix = rand ? rand_char(2).downcase : short_code.downcase
    self.location_code_prefix = prefix
    generate_prefix(true) unless valid_prefix?(prefix)
  end

  def rand_char(count)
    ('a'..'z').to_a.shuffle.join[0..count-1]
  end
end
