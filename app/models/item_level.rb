class ItemLevel < ActiveRecord::Base
  validates :start, :returns, :total, :day_of_week, :taken_at, :item, :client, presence: true
  validates :start, :returns, :total, :day_of_week, numericality: true

  belongs_to :item
  belongs_to :client
  belongs_to :user
  belongs_to :route_visit
end
