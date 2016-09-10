class RoutingPolicy < StandardPolicy
  def optimize_route?
    is_admin?
  end
end
