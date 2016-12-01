class ItemPolicy < StandardPolicy

  def index?
    is_admin_or_driver?
  end

  def show?
    is_admin_or_driver?
  end

  def get_related_resource?
    is_admin_or_driver?
  end

  def get_related_resources?
    is_admin_or_driver?
  end

end
