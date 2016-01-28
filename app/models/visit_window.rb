class VisitWindow < ActiveRecord::Base
  belongs_to :client
  has_many :route_visits
end
