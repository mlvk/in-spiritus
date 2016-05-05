class ItemCreditRatesController < ApplicationJsonApiResourcesController
  def index
    authorize ItemCreditRate
    super
  end

  def show
    authorize ItemCreditRate
    super
  end

  def create
    authorize ItemCreditRate
    super
  end

  def update
    authorize ItemCreditRate
    super
  end

  def get_related_resource
    authorize ItemCreditRate
    super
  end

  def get_related_resources
    authorize ItemCreditRate
    super
  end

end
