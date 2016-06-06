require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test "creates correct fulfillment structure on save" do
    order = build(:sales_order_with_items, :submitted)

    assert order.fulfillment.nil?, "Fulfillment was present before create and save"
    assert_equal(0, Fulfillment.all.count, "There was a fulfillment when there should't have been")

    order.save

    assert order.fulfillment.present?, "Fulfillment was not present after and save"
    assert_equal(1, Fulfillment.all.count, "Created the wrong number of fulfillments")
  end

  test "should clean up route_visit when deleted and no other orders present" do
    order = create(:sales_order_with_items, :submitted)

    order.destroy

    assert_equal Fulfillment.all.count, 0, "Fulfillment still present after order destroy"
    assert_equal RouteVisit.all.count, 0, "RouteVisit still present after order destroy"
  end

  test "should not delete route_visit when order deleted and other orders are present" do
    location = create(:location)
    order1 = create(:sales_order_with_items, :submitted, location:location)
    order2 = create(:sales_order_with_items, :submitted, location:location)

    assert_equal 2, Fulfillment.all.count, "Fulfillment still present after order destroy"
    assert_equal 1, RouteVisit.all.count, "RouteVisit still present after order destroy"

    order1.destroy

    assert_equal 1, RouteVisit.all.count, "RouteVisit not present after order destroy"
    assert_equal 1, Fulfillment.all.count, "Fulfillment not deleted after order destroy"
  end


  test "Should find or create route_visit when order date changes" do
    order = create(:sales_order_with_items)

    route_visit_id = order.fulfillment.route_visit.id

    order.delivery_date = order.delivery_date + 1
    order.save

    refute_equal route_visit_id, order.fulfillment.route_visit.id
  end

  test "Should not change route_visit when order saves but date is same" do
    order = create(:sales_order_with_items)

    generate_parent_route_visit_spy = Spy.on(order, :generate_parent_route_visit)

    order.save

    refute generate_parent_route_visit_spy.has_been_called?
  end

end
