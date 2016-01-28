class ClientVisitDaysController < ApplicationJsonApiResourcesController
  def index
    authorize ClientVisitDay
    super
  end

  def show
    authorize ClientVisitDay
    super
  end

  def create
    authorize ClientVisitDay
    super
  end

  def update
    authorize ClientVisitDay
    super
  end

  def get_related_resource
    authorize ClientVisitDay
    super
  end

  def get_related_resources
    authorize ClientVisitDay
    super
  end
end
