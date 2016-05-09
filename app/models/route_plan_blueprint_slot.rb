class RoutePlanBlueprintSlot < ActiveRecord::Base
	belongs_to :route_plan_blueprint
	belongs_to :address
end
