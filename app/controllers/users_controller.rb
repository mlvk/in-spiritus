class UsersController < ApplicationJsonApiResourcesController
  def index
    authorize User
    super
  end

  def show
    authorize User
    super
  end

  def create
    authorize User
    super
  end

  def update
    authorize User
    super
  end

  def destroy
    authorize User
    super
  end

  def get_related_resource
    authorize User
    super
  end

  def get_related_resources
    authorize User
    super
  end
end
