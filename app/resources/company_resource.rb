class CompanyResource < JSONAPI::Resource
  attributes  :code,
              :credit_rate,
              :name,
              :tag,
              :terms

  has_one  :price_tier
  has_many :locations
end
