class PriceTier < ActiveRecord::Base
	has_many :item_prices, :dependent => :destroy, autosave: true
	has_many :companies, dependent: :nullify, autosave: true
end
