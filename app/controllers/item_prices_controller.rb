class ItemPricesController < ApplicationJsonApiResourcesController
  def index
    authorize ItemPrice
    super
  end

  def show
    authorize ItemPrice
    super
  end

  def create
    authorize ItemPrice
    super
  end

  def update
    authorize ItemPrice
    super
  end

  def destroy
    authorize ItemPrice
    super
  end

  def get_related_resource
    authorize ItemPrice
    super
  end

  def get_related_resources
    authorize ItemPrice
    super
  end
end
