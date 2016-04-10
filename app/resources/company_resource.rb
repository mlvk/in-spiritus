class CompanyResource < JSONAPI::Resource
  attributes  :code,
              :name,
              :tag,
              :terms,
              :xero_state

  has_one  :price_tier
  has_many :locations
end
