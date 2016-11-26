class CompaniesController < ApplicationJsonApiResourcesController

  def index
    authorize Company
    super
  end

  def show
    authorize Company
    super
  end

  def create
    authorize Company
    super
  end

  def update
    authorize Company
    super
  end

  def destroy
    authorize Company
    company = Company.find(params['id'])

    company.mark_archived!

    render :nothing => true, :status => 204
  end

  def get_related_resource
    authorize Company
    super
  end

  def get_related_resources
    authorize Company
    super
  end
end
