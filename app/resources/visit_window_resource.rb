class VisitWindowResource < JSONAPI::Resource
  attributes  :min,
              :max,
              :service

  has_one   :address
  
  has_many  :visit_window_days
end
