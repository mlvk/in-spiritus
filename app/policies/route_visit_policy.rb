class RouteVisitPolicy < StandardPolicy

  def update?
  	is_admin_or_driver?
  end

  def get_related_resources?
    is_admin_or_driver?
  end

  def submit?
    is_admin_or_driver?
  end

end
