class RoutePlanBlueprintSlotsController < ApplicationJsonApiResourcesController
  def index
    authorize RoutePlanBlueprintSlot
    super
  end

  def show
    authorize RoutePlanBlueprintSlot
    super
  end

  def create
    authorize RoutePlanBlueprintSlot
    super
  end

  def update
    authorize RoutePlanBlueprintSlot
    super
  end

  def destroy
  	authorize RoutePlanBlueprintSlot
    super
  end

  def get_related_resource
    authorize RoutePlanBlueprintSlot
    super
  end

  def get_related_resources
    authorize RoutePlanBlueprintSlot
    super
  end
end
