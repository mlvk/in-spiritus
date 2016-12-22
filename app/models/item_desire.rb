class ItemDesire < ActiveRecord::Base
  belongs_to :location
  belongs_to :item

  def to_s
    item.name
  end
end
