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

  test "should mark order of draft? as deleted when http request order delete sent" do
    sign_in_as_admin

    order = create(:sales_order_with_items)

    assert order.draft?, "Should be in state draft?"
    assert_equal Fulfillment.count, 1, "Should have a Fulfillment"
    assert_equal Stock.count, 1, "Should have a Stock"
    assert_equal Pod.count, 1, "Should have a Pod"
    assert_equal CreditNote.count, 1, "Should have a CreditNote"

    delete(:destroy, {id:order.id})

    assert_equal Fulfillment.count, 0, "Should have deleted the Fulfillment"
    assert_equal Stock.count, 0, "Should have deleted the Stock"
    assert_equal Pod.count, 0, "Should have deleted the Pod"
    assert_equal CreditNote.count, 0, "Should have deleted the CreditNote"
    assert_equal Order.count, 0, "Should have deleted the order"
  end
end
