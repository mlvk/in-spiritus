class RouteVisitResource < JSONAPI::Resource
  attributes  :arrive_at,
              :depart_at,
              :position

  has_one :route_plan
  has_one :visit_window
  
  has_many  :fulfillments
end
