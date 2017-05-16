class OrderTemplateDayResource < JSONAPI::Resource

  attributes  :day,
              :enabled

  has_one :order_template
end
