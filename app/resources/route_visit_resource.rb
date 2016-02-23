class RouteVisitResource < JSONAPI::Resource
  attributes  :notes,
              :completed_at,
              :client_fingerprint,
              :arrive_at,
              :depart_at,
              :position,
              :fullfilled

  has_one :route_plan
  has_one :visit_window

  has_many :orders
  has_many :item_levels
end
