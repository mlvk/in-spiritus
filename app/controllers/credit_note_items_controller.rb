class CreditNoteItemsController < ApplicationJsonApiResourcesController

  def index
    authorize CreditNoteItem
    super
  end

  def show
    authorize CreditNoteItem
    super
  end

  def create
    authorize CreditNoteItem
    super
  end

  def update
    authorize CreditNoteItem
    super
  end

  def destroy
    authorize CreditNoteItem
    super
  end

  def get_related_resource
    authorize CreditNoteItem
    super
  end

  def get_related_resources
    authorize CreditNoteItem
    super
  end
end
