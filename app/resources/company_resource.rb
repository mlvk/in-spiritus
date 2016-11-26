class CompanyResource < JSONAPI::Resource
  include XeroResource
  include SyncableResource

  attributes  :name,
              :is_customer,
              :is_vendor,
              :terms,
              :location_code_prefix,
              :active_state

  has_one  :price_tier
  has_many :locations
  has_many :items

  filter   :is_customer
  filter   :is_vendor
  filter   :active_state
end
