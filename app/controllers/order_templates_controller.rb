class OrderTemplatesController < ApplicationJsonApiResourcesController

  def index
    authorize OrderTemplate
    super
  end

  def show
    authorize OrderTemplate
    super
  end

  def create
    authorize OrderTemplate
    super
  end

  def update
    authorize OrderTemplate
    super
  end

  def destroy
    authorize OrderTemplate
    super
  end

  def get_related_resource
    authorize OrderTemplate
    super
  end

  def get_related_resources
    authorize OrderTemplate
    super
  end
end
