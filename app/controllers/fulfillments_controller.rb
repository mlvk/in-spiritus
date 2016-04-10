class FulfillmentsController < ApplicationJsonApiResourcesController

  def index
    authorize Fulfillment
    super
  end

  def show
    authorize Fulfillment
    super
  end

  def create
    authorize Fulfillment
    super
  end

  def update
    authorize Fulfillment
    super
  end

  def destroy
    authorize Fulfillment
    super
  end

  def get_related_resource
    authorize Fulfillment
    super
  end

  def get_related_resources
    authorize Fulfillment
    super
  end
end
