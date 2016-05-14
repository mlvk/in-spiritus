require 'test_helper'

class SalesOrdersSyncerTest < ActiveSupport::TestCase

  # Local sync testing
  test "Remote deleted invoices should update to deleted locally" do
    order = create(:sales_order_with_items, :submitted)

    yaml_props = {
      invoice_number: order.order_number
    }

    VCR.use_cassette('sales_orders/002', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert order.voided?
  end

  test "Valid local sales orders should be created in xero" do
    order = create(:sales_order_with_items, :submitted)

    yaml_props = {
      response_invoice_id: 'new_xero_id',
      invoice_number: order.order_number
    }

    VCR.use_cassette('sales_orders/003', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    assert_equal(Order.first.xero_id, yaml_props[:response_invoice_id], "Xero id didn't match")
    assert Order.first.synced?, 'order was not marked as synced'
  end

  # Remote testing
  test "should not create a local order if order_number not found locally" do
    assert Order.all.empty?

    VCR.use_cassette('sales_orders/004') do
      SalesOrdersSyncer.new.sync_remote
    end

    assert Order.all.empty?
  end

  test "should void a local order when remote is voided" do
    order = create(:sales_order_with_items, :synced)

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number
    }

    VCR.use_cassette('sales_orders/005', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_remote
    end

    order.reload

    assert order.voided?, 'Order was not voided when remote syncing'
  end

  test "should update a local order when remote and local are out of sync, and local model is in state synced" do
    order = create(:sales_order_with_items, :synced, order_items_count: 1)

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number,
      item_code: order.order_items.first.item.name,
      item_quantity: 4
    }

    VCR.use_cassette('sales_orders/006', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_remote(10.minutes.ago)
    end

    assert order.order_items.all? {|order_item| order_item.quantity == 4}, 'Order item quantities did not match'
  end

  test "should remove order item if missing from remote record and local model is synced?" do
    order = create(:sales_order_with_items, :synced, order_items_count: 5)

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number
    }

    assert_equal(order.order_items.count, 5, "Wrong number of order items created")

    VCR.use_cassette('sales_orders/007', :erb => yaml_props) do
      SalesOrdersSyncer.new.sync_remote(10.minutes.ago)
    end

    assert order.order_items.empty?, 'Order items found when expected none'
  end

  test "should always honor xero's order_item attrs even when creating new record remotely" do
    order = create(:sales_order_with_items, :synced, order_items_count: 1)

    order.order_items.each do |order_item|
      order_item.quantity = 10
      order_item.save
    end

    order.mark_submitted!

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number,
      order_items: order.order_items,
      forced_xero_quantity: 15
    }

    VCR.use_cassette('sales_orders/008', :erb => yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert order.order_items.all? {|order_item| order_item.quantity == yaml_props[:forced_xero_quantity]}, 'Order item quantities did not match'
  end
end
