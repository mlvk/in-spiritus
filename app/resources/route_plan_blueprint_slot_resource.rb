class RoutePlanBlueprintSlotResource < JSONAPI::Resource
  attributes :position
  
  has_one :address
  has_one :route_plan_blueprint
end
