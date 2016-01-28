class ItemLevelResource < JSONAPI::Resource
  attributes :start, :returns, :total, :day_of_week, :taken_at
  has_one :item
  has_one :client
  has_one :user
  has_one :route_visit
end
