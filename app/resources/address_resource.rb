class AddressResource < JSONAPI::Resource
  attributes  :street,
              :city,
              :state,
              :zip,
              :lat,
              :lng

  has_many :locations
  has_many :route_visits
  has_many :visit_windows
end
