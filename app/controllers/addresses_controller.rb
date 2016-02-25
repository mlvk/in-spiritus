class AddressesController < ApplicationJsonApiResourcesController

  def index
    authorize Address
    super
  end

  def show
    authorize Address
    super
  end

  def create
    authorize Address
    super
  end

  def update
    authorize Address
    super
  end

  def destroy
    authorize Address
    super
  end

  def get_related_resource
    authorize Address
    super
  end

  def get_related_resources
    authorize Address
    super
  end
end
