class VisitWindowsController < ApplicationJsonApiResourcesController
  def index
    authorize VisitWindow
    super
  end

  def show
    authorize VisitWindow
    super
  end

  def create
    authorize VisitWindow
    super
  end

  def update
    authorize VisitWindow
    super
  end

  def get_related_resource
    authorize VisitWindow
    super
  end

  def get_related_resources
    authorize VisitWindow
    super
  end
end
