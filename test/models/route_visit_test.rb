require 'test_helper'

class RouteVisitTest < ActiveSupport::TestCase
  test "renders to_string correctly" do
    company = create(:company)
    location = create(:location, company:company)
    order = create(:order, location:location)
    fulfillment = create(:fulfillment, order:order)
    route_visit = create(:route_visit, fulfillments:[fulfillment])

    expected_string = "#{company.name} - #{location.code} - #{location.name}"
    assert_equal(expected_string, route_visit.to_string)
  end

  test "route_visits with empty fulfillments should be auto destroy when order is destroyed" do
    order = create(:sales_order_with_items, :submitted)

    assert_equal(RouteVisit.count, 1, "Should have created a RouteVisit")
    assert(!order.fulfillment.route_visit.destroyed?, "Should not be destroyed yet")

    order.destroy

    assert_equal(RouteVisit.count, 0, "Should no longer have any RouteVisits")
    assert(order.fulfillment.route_visit.destroyed?, "Should be destroyed")
  end

  test "route_visits with multiple fulfillments should not auto destroy when a single order is destroyed" do
    location = create(:location)
    order1 = create(:sales_order_with_items, :submitted, location:location)
    order2 = create(:sales_order_with_items, :submitted, location:location)

    assert(!order2.fulfillment.route_visit.destroyed?, "Should not be destroyed")

    order1.destroy

    assert(!order2.fulfillment.route_visit.destroyed?, "Should not be destroyed")
  end

end
