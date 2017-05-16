class OrderTemplateItem < ActiveRecord::Base

  belongs_to :order_template, touch: true
  belongs_to :item
end
