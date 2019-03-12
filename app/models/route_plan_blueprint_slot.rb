class RoutePlanBlueprintSlot < ActiveRecord::Base
	belongs_to :route_plan_blueprint, optional: true
	belongs_to :address, optional: true
end
