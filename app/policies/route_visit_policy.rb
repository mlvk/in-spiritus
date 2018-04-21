class RouteVisitPolicy < DriverPolicy

  def update?
  	is_admin_or_driver?
  end

  def submit?
    is_admin_or_driver?
  end

end
