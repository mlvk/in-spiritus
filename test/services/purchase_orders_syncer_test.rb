require 'test_helper'

class SalesOrdersSyncerTest < ActiveSupport::TestCase

  # Local sync testing
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

end
