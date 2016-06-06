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
    purchase_order = create(:purchase_order_with_items, :synced)

    yaml_props = {
      purchase_order_number: purchase_order.order_number,
      purchase_order_id: purchase_order.xero_id,
      order_items: purchase_order.order_items,
      forced_quantity: 99
    }

    VCR.use_cassette('purchase_orders/002', erb: yaml_props) do
      PurchaseOrdersSyncer.new.sync_remote(10.minutes.ago)
    end

    purchase_order.reload

    assert_equal(yaml_props[:purchase_order_id], purchase_order.xero_id)
    assert purchase_order.order_items.all? {|order_item| order_item.quantity.to_i == yaml_props[:forced_quantity]}, 'Order item quantities did not match'
  end

  test "Should not sync remote PO if no local matching PO is found" do
    VCR.use_cassette('purchase_orders/003') do
      PurchaseOrdersSyncer.new.sync_remote(10.minutes.ago)
    end

    assert_equal 0, Order.purchase_order.count
  end

  test "Local POs in state submitted should not be updated with remote changes." do
    purchase_order = create(:purchase_order_with_items, :submitted)

    local_quantity = 99
    local_unit_price = 11.00

    purchase_order.order_items.each do |order_item|
      order_item.quantity = local_quantity
      order_item.unit_price = local_unit_price
      order_item.save
    end

    yaml_props = {
      purchase_order_number: purchase_order.order_number,
      purchase_order_id: 'purchase_order_id',
      order_items: purchase_order.order_items,
      forced_quantity: 150,
      forced_unit_price: 21.00
    }

    VCR.use_cassette('purchase_orders/004', erb: yaml_props) do
      PurchaseOrdersSyncer.new.sync_remote(10.minutes.ago)
    end

    purchase_order.reload

    purchase_order.order_items.each do |order_item|
      assert_equal local_quantity, order_item.quantity.to_i
      assert_equal local_unit_price, order_item.unit_price.to_i
    end

  end

end


# 1. Should we replace local pos when there is one on the remote?

  # we should only sync local POs that have remote changes when there is a matching local PO.
  # Example: If we create a PO in xero upon pickup of the PO.
  # After it is synced with xero if there are changes made in xero, we should then sync back locally.
  # If a PO is created in xero and there is no matching PO locally, this should not sync locally.


  # If there are local changes, and there are also remote changes. The local changes should not be overridden.
  # We should keep the local PO in a state of submitted.

  # POs in state submitted should not be changed when there are remote changes.

  # We should only create POs in xeroupon delivery

# 2. What about missing POs on local system?
# Vendors like multiple, horn etc.

# 3. Should we create POs in draft mode as soon as generated locally?
# then we can transition state from DRAFT to AUTHORIZED

# 4. If deleted while in draft, should we wipe from the system?

# If we sync everything we should just start the timestamp short period back
