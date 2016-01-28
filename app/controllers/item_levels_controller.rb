class ItemLevelsController < ApplicationJsonApiResourcesController

  def index
    authorize ItemLevel
    super
  end

  def show
    authorize ItemLevel
    super
  end

  def create
    authorize ItemLevel
    super
  end

  def update
    authorize ItemLevel
    super
  end

  def destroy
    authorize RouteVisit
    super
  end

  def get_related_resource
    authorize ItemLevel
    super
  end

  def get_related_resources
    authorize ItemLevel
    super
  end
end
