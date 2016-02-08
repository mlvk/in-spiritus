class Company < ActiveRecord::Base

  validates :name, :code, uniqueness: { case_sensitive: false }

  has_many :locations, :dependent => :destroy, autosave: true

  belongs_to :price_tier

	has_many :item_prices, through: :price_tier

	def price_for_item (item)
		match = item_prices
			.where(item:item)
			.first

		match.present? ? match.price : 0.0
	end

end
