class OrderPolicy < StandardPolicy
  def stub_orders?
    @current_user.admin?
  end
end
