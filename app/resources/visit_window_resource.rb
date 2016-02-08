class VisitWindowResource < JSONAPI::Resource
  attributes  :notes,
              :min_arrival,
              :max_arrival

  has_one :location
end
