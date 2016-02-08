class CompanyResource < JSONAPI::Resource
  attributes  :code,
              :name,
              :tag,
              :credit_rate,
              :terms

  has_one  :price_tier
  has_many :locations

end
