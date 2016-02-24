class AddressResource < JSONAPI::Resource
  attributes  :street,
              :city,
              :state,
              :zip,
              :lat,
              :lng

  has_many :locations
end
