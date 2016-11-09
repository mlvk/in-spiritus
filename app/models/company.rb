class Company < ActiveRecord::Base
  include AASM
  include StringUtils

  validates :name, presence: true
  validates :price_tier, presence: true, if: :is_customer

  before_save :pre_process_saving_data

  aasm :company, :column => :xero_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :synced

    event :mark_pending do
      transitions :from => [:pending, :synced], :to => :pending
    end

    event :mark_synced do
      transitions :from => [:pending, :synced], :to => :synced
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
  def pre_process_saving_data
    # Generate location code prefix
    self.location_code_prefix = trim_and_downcase location_code_prefix
    generate_prefix unless valid_prefix?

    # trim data
    self.name = trim name
  end

  def valid_prefix?
    match = Company.find_by(location_code_prefix: location_code_prefix)
    (match.nil? || match == self) && location_code_prefix.present?
  end

  def generate_prefix(rand = false)
    prefix = rand ? rand_char(2).downcase : short_code.downcase
    self.location_code_prefix = prefix
    generate_prefix(true) unless valid_prefix?
  end

  def rand_char(count)
    ('a'..'z').to_a.shuffle.join[0..count-1]
  end
end
