class ItemDesiresController < ApplicationJsonApiResourcesController
  def index
    authorize ItemDesire
    super
  end

  def show
    authorize ItemDesire
    super
  end

  def create
    authorize ItemDesire
    super
  end

  def update
    authorize ItemDesire
    super
  end

  def get_related_resource
    authorize ItemDesire
    super
  end

  def get_related_resources
    authorize ItemDesire
    super
  end

end
