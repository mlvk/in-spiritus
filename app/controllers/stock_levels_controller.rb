class StockLevelsController < ApplicationJsonApiResourcesController

  def index
    authorize StockLevel
    super
  end

  def show
    authorize StockLevel
    super
  end

  def create
    authorize StockLevel
    super
  end

  def update
    authorize StockLevel
    super
  end

  def destroy
    authorize StockLevel
    super
  end

  def get_related_resource
    authorize StockLevel
    super
  end

  def get_related_resources
    authorize StockLevel
    super
  end
end
