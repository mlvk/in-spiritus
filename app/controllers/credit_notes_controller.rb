class CreditNotesController < ApplicationJsonApiResourcesController

  def index
    authorize CreditNote
    super
  end

  def show
    authorize CreditNote
    super
  end

  def create
    authorize CreditNote
    super
  end

  def update
    authorize CreditNote
    super
  end

  def destroy
    authorize CreditNote
    super
  end

  def get_related_resource
    authorize CreditNote
    super
  end

  def get_related_resources
    authorize CreditNote
    super
  end
end
