class Company < ActiveRecord::Base
  include AASM
  include SyncableModel
  include XeroRecord
  include StringUtils

  ACTIVE_STATUS = 'ACTIVE'
  ARCHIVED_STATUS = 'ARCHIVED'

  validates :name, presence: true
  validates :price_tier, presence: true, if: :is_customer

  before_save :clean_fields

  aasm :active_state, :column => :active_state, :skip_validation_on_save => true do
    state :active, :initial => true
    state :archived

    event :mark_active do
      transitions :from => [:active, :archived], :to => :active
    end

    event :mark_archived do
      transitions :from => [:active, :archived], :to => :archived
    end
  end

  enum active_state: [ :active, :archived ]

  validates :name, uniqueness: { case_sensitive: false, message: "Company name was duplicated" }

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

  def financial_data_for_date_range(start_date, end_date)
    raw_data = locations
      .select { |l| l.active }
      .map { |l| l.financial_data_for_date_range(start_date, end_date) }

  	total_sales_revenue = raw_data.inject(0) { |acc, cur| acc = acc + cur[:total_sales_revenue] }
		total_dist_revenue = raw_data.inject(0) { |acc, cur| acc = acc + cur[:total_dist_revenue] }
		total_spoilage = raw_data.inject(0) { |acc, cur| acc = acc + cur[:total_spoilage] }

    {
      id: id,
      name: name,
      raw_data: raw_data,
      total_sales_revenue: total_sales_revenue,
      total_dist_revenue: total_dist_revenue,
      total_spoilage: total_spoilage
    }
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
  def clean_fields
    self.location_code_prefix = trim_and_downcase location_code_prefix

    generate_prefix unless valid_prefix?

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
