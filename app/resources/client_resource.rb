class ClientResource < JSONAPI::Resource
  attributes  :code,
              :company,
              :nickname,
              :terms,
              :delivery_rate,
              :credit_rate,
              :active

  has_one  :price_tier
  has_many :visit_windows
  has_many :client_item_desires
  has_many :client_visit_days

  filter :active
end
