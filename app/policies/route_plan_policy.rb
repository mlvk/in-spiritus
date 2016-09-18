class RoutePlanPolicy < StandardPolicy

  def index?
    is_admin_or_driver?
  end

  def show?
    is_admin_or_driver?
  end
  
end
