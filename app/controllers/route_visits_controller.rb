class RouteVisitsController < ApplicationJsonApiResourcesController
  def index
    authorize RouteVisit
    super
  end

  def show
    authorize RouteVisit
    super
  end

  def create
    authorize RouteVisit
    super
  end

  def update
    authorize RouteVisit
    super
  end

  def destroy
    authorize RouteVisit
    super
  end

  def get_related_resource
    authorize RouteVisit
    super
  end

  def get_related_resources
    authorize RouteVisit
    super
  end

end
