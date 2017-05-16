class OrderTemplateResource < JSONAPI::Resource

  attributes  :start_date,
              :frequency

  has_one :location

  has_many :order_template_items
  has_many :order_template_days
end
