class CustomOrdersController < ApplicationJsonApiResourcesController
  def index
    authorize CustomOrder
    super
  end

  def show
    authorize CustomOrder
    super
  end

  def create
    authorize CustomOrder
    super
  end

  def update
    authorize CustomOrder
    super
  end

  def get_related_resource
    authorize CustomOrder
    super
  end

  def get_related_resources
    authorize CustomOrder
    super
  end
end
