class StockLevelPolicy < DriverPolicy

  def create?
  	is_admin_or_driver?
  end

  def update?
  	is_admin_or_driver?
  end

end
