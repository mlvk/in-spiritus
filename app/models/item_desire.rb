class ItemDesire < ActiveRecord::Base
  belongs_to :location, optional: true
  belongs_to :item, optional: true

  def to_s
    item.name
  end
end
