class ReportsPolicy < StandardPolicy
  def customer_financials_by_range?
    is_admin?
  end
end
