require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  def setup
    prep_jr_headers
  end

  test "admins can duplicate sales orders" do
    sign_in_as_admin

    order = create(:sales_order_with_items, delivery_date:Date.today)

    assert_equal(Order.sales_order.count, 1)

    post(:duplicate_sales_orders, {fromDate:Date.today, toDate:Date.today + 1})

    assert_equal(Order.sales_order.count, 2)
  end

  test "calling duplicate sales order with invalid dates returns an error" do
    sign_in_as_admin

    order = create(:sales_order_with_items, delivery_date:Date.today)

    response = JSON.parse(post(:duplicate_sales_orders).body)

    assert_equal(response["status"], false)
  end

  test "only duplicates sales orders from the requested date" do
    sign_in_as_admin

    order = create(:sales_order_with_items, delivery_date:Date.today)
    order_different_date = create(:sales_order_with_items, delivery_date:Date.today-1)

    assert_equal(Order.sales_order.count, 2)

    post(:duplicate_sales_orders, {fromDate:Date.today, toDate:Date.today + 1})

    assert_equal(Order.sales_order.count, 3)
  end

  test "should clean up fulfillment when order deleted" do
    sign_in_as_admin

    order = create(:sales_order_with_items, :submitted)

    assert_equal Stock.count, 1, "Should have a Stock"
    assert_equal Pod.count, 1, "Should have a Pod"
    assert_equal CreditNote.count, 1, "Should have a CreditNote"

    delete(:destroy, {id:order.id})

    assert_equal Stock.count, 0, "Should not have a Stock"
    assert_equal Pod.count, 0, "Should not have a Pod"
    assert_equal CreditNote.count, 0, "Should not have a CreditNote"
  end

  test "should clean up route_visit when order deleted and no other orders present" do
    sign_in_as_admin

    order = create(:sales_order_with_items, :submitted)

    delete(:destroy, {id:order.id})

    assert_equal Fulfillment.count, 0, "Fulfillment still present after order destroy"
    assert_equal RouteVisit.count, 0, "RouteVisit still present after order destroy"
  end

  test "should not delete route_visit when order deleted and other orders are present" do
    sign_in_as_admin

    location = create(:location)
    order1 = create(:sales_order_with_items, :submitted, location:location)
    order2 = create(:sales_order_with_items, :submitted, location:location)

    assert_equal 2, Fulfillment.count, "Fulfillment still present after order destroy"
    assert_equal 1, RouteVisit.count, "RouteVisit still present after order destroy"

    delete(:destroy, {id:order1.id})

    assert_equal 1, RouteVisit.count, "RouteVisit not present after order destroy"
    assert_equal 1, Fulfillment.count, "Fulfillment not deleted after order destroy"
  end

  test "should not remove fulfillment if order synced with xero" do
    sign_in_as_admin

    order = create(:sales_order_with_items, :synced)

    assert_equal Stock.count, 1, "Should have a Stock"
    assert_equal Pod.count, 1, "Should have a Pod"
    assert_equal CreditNote.count, 1, "Should have a CreditNote"

    delete(:destroy, {id:order.id})

    order.reload

    assert order.voided?, "Should have become voided on delete"
    assert_equal Stock.count, 1, "Should not have a Stock"
    assert_equal Pod.count, 1, "Should not have a Pod"
    assert_equal CreditNote.count, 1, "Should not have a CreditNote"
  end
end
