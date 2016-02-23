class OrderItemsController < ApplicationJsonApiResourcesController
  def index
    authorize OrderItem
    super
  end

  def show
    authorize OrderItem
    super
  end

  def create
    authorize OrderItem
    super
  end

  def update
    authorize OrderItem
    super
  end

  def destroy
  	authorize OrderItem
    super
  end

  def get_related_resource
    authorize OrderItem
    super
  end

  def get_related_resources
    authorize OrderItem
    super
  end
end
