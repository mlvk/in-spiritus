class OrderPolicy < DriverPolicy
  def stub_orders?
    @current_user.admin?
  end

  def duplicate_sales_orders?
    @current_user.admin?
  end

  def generate_pdf?
    @current_user.admin?
  end

  def update?
  	is_admin_or_driver?
  end

end
