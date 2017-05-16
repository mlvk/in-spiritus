class OrderTemplateItemResource < JSONAPI::Resource

  attributes  :quantity

  has_one :order_template
  has_one :item
end
