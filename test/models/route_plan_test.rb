require 'test_helper'

class RoutePlanTest < ActiveSupport::TestCase
  test "returns sorted route_visits collection based on position" do
    route_plan = create(:route_plan)

    route_visit2 = create(:route_visit, position: 2, route_plan:route_plan)
    route_visit1 = create(:route_visit, position: 1, route_plan:route_plan)
    route_visit3 = create(:route_visit, position: 3, route_plan:route_plan)

    route_plan.reload

    assert_equal(route_plan.route_visits.first, route_visit1, "Wrong route visit in the first position")
  end

  test "delivery_visits returns just the delivery visits" do
    route_plan = create(:route_plan)

    purchase_order = create(:order, :purchase_order)
    pickup_visit = create(:route_visit, route_plan:route_plan)
    pickup_fulfillment = create(:fulfillment, order:purchase_order, route_visit:pickup_visit)

    sales_order = create(:order, :sales_order)
    delivery_visit = create(:route_visit, route_plan:route_plan)
    pickup_fulfillment = create(:fulfillment, order:sales_order, route_visit:delivery_visit)

    route_plan.reload

    assert_equal(route_plan.route_visits.count, 2, "Wrong number of route_visits")
    assert_equal(route_plan.delivery_visits.count, 1, "Wrong number of route_visits")
  end

  test "has_multiple? true when mutliple fulfillments reference the same route_visit" do
    route_plan = create(:route_plan)

    route_visit = create(:route_visit, route_plan:route_plan)

    purchase_order = create(:order, :purchase_order)
    pickup_fulfillment = create(:fulfillment, order:purchase_order, route_visit:route_visit)

    sales_order = create(:order, :sales_order)
    pickup_fulfillment = create(:fulfillment, order:sales_order, route_visit:route_visit)

    route_plan.reload

    assert(route_plan.route_visits.first.has_multiple_fulfillments?, "Should be has_multiple_fulfillments? true")
  end
end
