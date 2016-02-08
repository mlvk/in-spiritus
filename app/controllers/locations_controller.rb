class LocationsController < ApplicationJsonApiResourcesController
  def index
    authorize Location
    super
  end

  def show
    authorize Location
    super
  end

  def create
    authorize Location
    super
  end

  def update
    authorize Location
    super
  end

  def get_related_resource
    authorize Location
    super
  end

  def get_related_resources
    authorize Location
    super
  end
end
