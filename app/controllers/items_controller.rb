class ItemsController < ApplicationJsonApiResourcesController
  def index
    authorize Item
    super
  end

  def show
    authorize Item
    super
  end

  def update
    authorize Item
    super
  end

  def create
    authorize Item
    super
  end

  def destroy
    authorize Item
    super
  end

  def get_related_resource
    authorize Item
    super
  end

  def get_related_resources
    authorize Item
    super
  end

end
