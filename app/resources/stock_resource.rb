class StockResource < JSONAPI::Resource
  attributes :taken_at,
             :day_of_week

  has_many :stock_levels
  has_one  :location
  has_one  :user
end
