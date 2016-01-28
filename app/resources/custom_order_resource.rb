class CustomOrderResource < JSONAPI::Resource
  attributes :delivery_date, :fullfilled
  has_one :route_visit
  has_one :visit_window

  filter :delivery_date
end
