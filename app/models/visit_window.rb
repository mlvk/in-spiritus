class VisitWindow < ActiveRecord::Base
  belongs_to :location
  has_many :route_visits
end
