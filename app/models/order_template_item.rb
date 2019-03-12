class OrderTemplateItem < ActiveRecord::Base

  belongs_to :order_template, touch: true, optional: true
  belongs_to :item, optional: true
end
