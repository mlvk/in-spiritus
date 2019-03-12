class RoutePlanBlueprint < ActiveRecord::Base
	has_many 		:route_plan_blueprint_slots, :dependent => :destroy, autosave: true
	belongs_to 	:user, optional: true
end
