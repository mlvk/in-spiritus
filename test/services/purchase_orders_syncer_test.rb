require 'test_helper'

class PurchaseOrdersSyncerTest < ActiveSupport::TestCase

  # Local sync testing

  # Should we take two paths for looking up a local model.
  # If we do that, it would give us more control over applying predicates.
  # This would require a change to all other syncers.
  # Other option to to always force remote changes to propagate.
  # Think about it!
  test "Creates remote POs when local valid POs are submitted" do
    purchase_order = create(:purchase_order_with_items, :submitted)

    yaml_props = {
      purchase_order_number: purchase_order.order_number,
      remote_purchase_order_id: 'new_order_id'
    }

    VCR.use_cassette('purchase_orders/001', erb: yaml_props) do
      PurchaseOrdersSyncer.new.sync_local
    end

    purchase_order.reload

    assert_equal(yaml_props[:remote_purchase_order_id], purchase_order.xero_id)
  end

  test "Should update local PO when there are remote changes with a matching local PO and local PO is in state synced" do
    purchase_order = create(:purchase_order_with_items, :synced, :with_xero_id)

    yaml_props = {
      purchase_order_number: purchase_order.order_number,
      purchase_order_id: purchase_order.xero_id,
      order_items: purchase_order.order_items,
      forced_quantity: 99
    }

    VCR.use_cassette('purchase_orders/002', erb: yaml_props) do
      PurchaseOrdersSyncer.new.sync_remote(10.minutes.from_now)
    end

    purchase_order.reload

    assert_equal(yaml_props[:purchase_order_id], purchase_order.xero_id)
    assert purchase_order.order_items.all? {|order_item| order_item.quantity.to_i == yaml_props[:forced_quantity]}, 'Order item quantities did not match'
  end

  test "Should not sync remote PO if no local matching PO is found" do
    VCR.use_cassette('purchase_orders/003') do
      PurchaseOrdersSyncer.new.sync_remote(10.minutes.from_now)
    end

    assert_equal 0, Order.purchase_order.count
  end

  test "Local POs in state submitted should also be updated with remote changes." do
    purchase_order = create(:purchase_order_with_items, :submitted)

    local_quantity = 99
    local_unit_price = 11.00

    remote_quantity = 150
    remote_unit_price = 21.50

    purchase_order.order_items.each do |order_item|
      order_item.quantity = local_quantity
      order_item.unit_price = local_unit_price
      order_item.save
    end

    yaml_props = {
      purchase_order_number: purchase_order.order_number,
      purchase_order_id: 'purchase_order_id',
      order_items: purchase_order.order_items,
      forced_quantity: remote_quantity,
      forced_unit_price: remote_unit_price
    }

    VCR.use_cassette('purchase_orders/004', erb: yaml_props) do
      PurchaseOrdersSyncer.new.sync_remote(10.minutes.from_now)
    end

    purchase_order.reload

    purchase_order.order_items.each do |order_item|
      assert_equal remote_quantity, order_item.quantity.to_i
      assert_equal remote_unit_price, order_item.unit_price
    end

  end
end
