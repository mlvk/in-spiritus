class CompanyResource < JSONAPI::Resource
  attributes  :name,
              :is_customer,
              :is_vendor,
              :terms,
              :xero_state

  has_one  :price_tier
  has_many :locations
  has_many :items

  filter   :is_customer
  filter   :is_vendor

  before_save do
    @model.xero_state = Company.xero_states[:pending]
  end
end
