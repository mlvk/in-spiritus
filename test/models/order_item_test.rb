require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  test "should be able to clone an order item to a new order" do
    old_order = create(:order)
    new_order = create(:order)
    order_item = create(:order_item, order:old_order)

    assert_empty(new_order.order_items, "Expected order_items to be empty")

    duplicated_order_item = order_item.clone(order:new_order)

    assert_equal(new_order.order_items.count, 1, "Expected there to be 1 order_item after the clone")
  end

  test "raises an error when cloned without a new order" do
    old_order = create(:order)
    order_item = create(:order_item, order:old_order)

    assert_raise do
      order_item.clone
    end
  end
end
