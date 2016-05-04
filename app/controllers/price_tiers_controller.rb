class PriceTiersController < ApplicationJsonApiResourcesController
  def index
    authorize PriceTier
    super
  end

  def show
    authorize PriceTier
    super
  end

  def create
    authorize PriceTier
    super
  end

  def get_related_resource
    authorize PriceTier
    super
  end

  def get_related_resources
    authorize PriceTier
    super
  end
end
