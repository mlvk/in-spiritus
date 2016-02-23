class VisitWindowDaysController < ApplicationJsonApiResourcesController
  def index
    authorize VisitWindowDay
    super
  end

  def show
    authorize VisitWindowDay
    super
  end

  def create
    authorize VisitWindowDay
    super
  end

  def update
    authorize VisitWindowDay
    super
  end

  def get_related_resource
    authorize VisitWindowDay
    super
  end

  def get_related_resources
    authorize VisitWindowDay
    super
  end
end
