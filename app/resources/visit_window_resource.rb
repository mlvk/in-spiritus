class VisitWindowResource < JSONAPI::Resource
  attributes  :min,
              :max,
              :service

  has_one :location
  has_one :route_visit
  has_many :visit_window_days
end
