class RouteVisitResource < JSONAPI::Resource
  attributes  :arrive_at,
              :depart_at,
              :position,
              :date

  has_one :route_plan
  has_one :address

  has_many  :fulfillments
end
