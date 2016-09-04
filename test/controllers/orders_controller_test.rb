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
end
