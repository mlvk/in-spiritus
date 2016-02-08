class LocationResource < JSONAPI::Resource
  attributes  :name,
              :code,
              :delivery_rate,
              :active

  has_one  :company
  has_one  :address
  has_many :visit_windows
  has_many :item_desires
  has_many :visit_days

  filter :active
end
