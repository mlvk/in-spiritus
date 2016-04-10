class PodsController < ApplicationJsonApiResourcesController

  def index
    authorize Pod
    super
  end

  def show
    authorize Pod
    super
  end

  def create
    authorize Pod
    super
  end

  def update
    authorize Pod
    super
  end

  def destroy
    authorize Pod
    super
  end

  def get_related_resource
    authorize Pod
    super
  end

  def get_related_resources
    authorize Pod
    super
  end
end
