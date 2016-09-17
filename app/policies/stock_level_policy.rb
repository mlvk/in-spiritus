class StockLevelPolicy < StandardPolicy

  def create?
  	is_admin_or_driver?
  end

end
