class OrderTemplateItemsController < ApplicationJsonApiResourcesController
  
  def index
    authorize OrderTemplateItem
    super
  end

  def show
    authorize OrderTemplateItem
    super
  end

  def create
    authorize OrderTemplateItem
    super
  end

  def update
    authorize OrderTemplateItem
    super
  end

  def destroy
    authorize OrderTemplateItem
    super
  end

  def get_related_resource
    authorize OrderTemplateItem
    super
  end

  def get_related_resources
    authorize OrderTemplateItem
    super
  end
end
