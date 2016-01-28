class RoutePlan < ActiveRecord::Base
	belongs_to :user
	has_many :route_visits, :dependent => :destroy, autosave: true
end
