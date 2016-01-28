class ClientItemDesiresController < ApplicationJsonApiResourcesController
  def index
    authorize ClientItemDesire
    super
  end

  def show
    authorize ClientItemDesire
    super
  end

  def create
    authorize ClientItemDesire
    super
  end

  def update
    authorize ClientItemDesire
    super
  end

  def get_related_resource
    authorize ClientItemDesire
    super
  end

  def get_related_resources
    authorize ClientItemDesire
    super
  end

end
