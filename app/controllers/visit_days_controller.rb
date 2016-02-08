class VisitDaysController < ApplicationJsonApiResourcesController
  def index
    authorize VisitDay
    super
  end

  def show
    authorize VisitDay
    super
  end

  def create
    authorize VisitDay
    super
  end

  def update
    authorize VisitDay
    super
  end

  def get_related_resource
    authorize VisitDay
    super
  end

  def get_related_resources
    authorize VisitDay
    super
  end
end
