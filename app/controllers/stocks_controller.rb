class StocksController < ApplicationJsonApiResourcesController

  def index
    authorize Stock
    super
  end

  def show
    authorize Stock
    super
  end

  def create
    authorize Stock
    super
  end

  def update
    authorize Stock
    super
  end

  def destroy
    authorize Stock
    super
  end

  def get_related_resource
    authorize Stock
    super
  end

  def get_related_resources
    authorize Stock
    super
  end
end
