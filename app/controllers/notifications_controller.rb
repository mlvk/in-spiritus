class NotificationsController < ApplicationJsonApiResourcesController
  def index
    authorize Notification
    super
  end

  def show
    authorize Notification
    super
  end

  def create
    authorize Notification
    super
  end

  def update
    authorize Notification
    super
  end

   def destroy
    authorize Notification
    super
  end

  def get_related_resource
    authorize Notification
    super
  end

  def get_related_resources
    authorize Notification
    super
  end
end
