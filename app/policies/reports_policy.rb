class ReportsPolicy < StandardPolicy
  def customer_financials_by_range?
    is_admin?
  end

  def product_financials_by_range?
    is_admin?
  end
end
