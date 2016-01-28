class RoutePlansController < ApplicationJsonApiResourcesController
  def index
    authorize RoutePlan
    super
  end

  def show
    authorize RoutePlan
    super
  end

  def create
    authorize RoutePlan
    super
  end

  def update
    authorize RoutePlan
    super
  end

  def destroy
    authorize RouteVisit
    super
  end

  def get_related_resource
    authorize RoutePlan
    super
  end

  def get_related_resources
    authorize RoutePlan
    super
  end
end
