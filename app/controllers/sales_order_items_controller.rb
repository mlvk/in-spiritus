class SalesOrderItemsController < ApplicationJsonApiResourcesController
  def index
    authorize SalesOrderItem
    super
  end

  def show
    authorize SalesOrderItem
    super
  end

  def create
    authorize SalesOrderItem
    super
  end

  def update
    authorize SalesOrderItem
    super
  end

  def get_related_resource
    authorize SalesOrderItem
    super
  end

  def get_related_resources
    authorize SalesOrderItem
    super
  end
end
