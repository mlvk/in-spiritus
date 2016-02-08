class AddressResource < JSONAPI::Resource
  attributes  :address,
              :city,
              :state,
              :zip,
              :lat,
              :lon

  has_many :locations
end
