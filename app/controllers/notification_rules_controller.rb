class NotificationRulesController < ApplicationJsonApiResourcesController
  def index
    authorize NotificationRule
    super
  end

  def show
    authorize NotificationRule
    super
  end

  def create
    authorize NotificationRule
    super
  end

  def update
    authorize NotificationRule
    super
  end

   def destroy
    authorize NotificationRule
    super
  end

  def get_related_resource
    authorize NotificationRule
    super
  end

  def get_related_resources
    authorize NotificationRule
    super
  end
end
