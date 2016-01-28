class ClientsController < ApplicationJsonApiResourcesController
  def index
    authorize Client
    super
  end

  def show
    authorize Client
    super
  end

  def create
    authorize Client
    super
  end

  def update
    authorize Client
    super
  end

  def get_related_resource
    authorize Client
    super
  end

  def get_related_resources
    authorize Client
    super
  end
end
