class VisitWindowResource < JSONAPI::Resource
  attributes  :address,
              :city,
              :state,
              :zip,
              :lat,
              :lon,
              :service,
              :notes,
              :arrive_at,
              :depart_at

  has_one :client
end
