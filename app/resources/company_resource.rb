class CompanyResource < JSONAPI::Resource
  attributes  :name,
              :tag,
              :terms,
              :xero_state

  has_one  :price_tier
  has_many :locations

  filter     :tag

  before_save do
    @model.xero_state = Company.xero_states[:pending]
  end
end
