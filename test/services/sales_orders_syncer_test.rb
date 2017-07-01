require 'test_helper'

class SalesOrdersSyncerTest < ActiveSupport::TestCase

  test "Remote deleted invoices should update to deleted locally" do
    order = create(:sales_order_with_items, :submitted, :with_xero_id)

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number,
      invoice_status: 'DELETED'
    }

    VCR.use_cassette('sales_orders/query_by_id_and_match', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert order.deleted?
  end

  test "Remote voided invoices should update to voided locally" do
    order = create(:sales_order_with_items, :authorized, :with_xero_id)

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number,
      invoice_status: 'VOIDED'
    }

    VCR.use_cassette('sales_orders/query_by_id_and_match', erb: yaml_props) do
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

    VCR.use_cassette('sales_orders/query_not_found_create', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    assert_equal(Order.first.xero_id, yaml_props[:response_invoice_id], "Xero id didn't match")
    assert Order.first.synced?, 'order was not marked as synced'
  end

  test "should not create a local order if order_number not found locally" do
    assert Order.all.empty?

    VCR.use_cassette('sales_orders/004') do
      SalesOrdersSyncer.new.sync_remote
    end

    assert Order.all.empty?
  end

  test "should update a local order when remote and local are out of sync, and local model is in state synced" do
    order = create(:sales_order_with_items, :synced, :with_xero_id, order_items_count: 1)

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number,
      item_code: order.order_items.first.item.code,
      item_quantity: 4,
      updated_date_utc: 10.minutes.from_now
    }

    VCR.use_cassette('sales_orders/006', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_remote
    end

    assert order.order_items.all? {|order_item| order_item.quantity == 4}, 'Order item quantities did not match'
  end

  test "should not 0 out quantity of local orderitems if missing from remote record and local model is synced?" do
    order = create(:sales_order_with_items, :synced, order_items_count: 5)
    order.order_items.each {|oi|
      oi.quantity = 15
      oi.save
    }

    yaml_props = {
      record_id: order.xero_id,
      record_number: order.order_number,
      record_status: 'AUTHORISED',
      updated_date_utc: 10.minutes.from_now
    }

    assert_equal(order.order_items.count, 5, "Wrong number of order items created")

    VCR.use_cassette('sales_orders/query_changed_query_record', :erb => yaml_props) do
      SalesOrdersSyncer.new.sync_remote(10.minutes.from_now)
    end

    assert_equal order.order_items.count, 5, 'Wrong number of order items found'

    order.reload
    assert order.order_items.all? {|oi| oi.quantity == 0}, "orderitem quantities should have become 0"
  end

  test "should not update local model if local has been updated since sooner than remote record" do
    order = create(:sales_order_with_items, :synced, order_items_count: 5)
    order.order_items.each {|oi|
      oi.quantity = 15
      oi.save
    }

    yaml_props = {
      record_id: order.xero_id,
      record_number: order.order_number,
      record_status: 'AUTHORISED',
      updated_date_utc: 10.minutes.ago
    }

    assert_equal(order.order_items.count, 5, "Wrong number of order items created")

    VCR.use_cassette('sales_orders/query_changed_query_record', :erb => yaml_props) do
      SalesOrdersSyncer.new.sync_remote(10.minutes.ago)
    end

    assert_equal order.order_items.count, 5, 'Wrong number of order items found'

    order.reload
    assert order.order_items.all? {|oi| oi.quantity == 15}, "orderitem quantities should not have become 0"
  end

  test "should always honor xero's order_item attrs even when creating new record remotely" do
    order = create(:sales_order_with_items, :with_xero_id, order_items_count: 1)

    order.order_items.each do |oi|
      oi.quantity = 10
      oi.save
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

    assert order.order_items.all? {|oi| oi.quantity == yaml_props[:forced_xero_quantity]}, 'Order item quantities did not match'
  end

  test "Should create xero record if order_items quantities are 0" do
    order = create(:sales_order_with_items, :submitted)

    order.order_items.each {|oi|
      oi.unit_price = 0
      oi.quantity = 5
      oi.save
    }

    yaml_props = {
      record_id: 'new_xero_id',
      record_number: order.order_number,
      order_items: order.order_items
    }

    VCR.use_cassette('sales_orders/query_by_number_not_found', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert_equal(Order.first.xero_id, yaml_props[:record_id], "Xero id didn't match")
    assert Order.first.synced?, 'order was not marked as synced'
  end

  test "Should not create xero record if order is draft and greater than or equal to current day" do
    order = create(:sales_order_with_items, delivery_date:1.day.from_now.to_date)

    yaml_props = {
      response_invoice_id: 'new_xero_id',
      invoice_number: order.order_number
    }

    VCR.use_cassette('sales_orders/query_not_found_create', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    refute Order.first.has_synced_with_xero?, 'Order has a xero id when it should not'
    refute Order.first.synced?, 'order was marked as synced'
  end

  test "Should create xero record if order is draft but also 1 day old" do
    order = create(:sales_order_with_items, delivery_date:1.day.ago.to_date)

    yaml_props = {
      response_invoice_id: 'new_xero_id',
      invoice_number: order.order_number
    }

    VCR.use_cassette('sales_orders/query_not_found_create', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    assert_equal(Order.first.xero_id, yaml_props[:response_invoice_id], "Xero id didn't match")
    assert Order.first.synced?, 'order was not marked as synced'
  end

  test "Should not try to sync remote when remote has payments" do
    order = create(:sales_order_with_items, :submitted, :with_xero_id)

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number,
      invoice_status: 'AUTHORISED'
    }

    VCR.use_cassette('sales_orders/query_by_id_and_match_with_payments', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert order.synced?
  end

  test "Should not try to sync remote when remote has credits" do
    order = create(:sales_order_with_items, :submitted, :with_xero_id)

    yaml_props = {
      invoice_id: order.xero_id,
      invoice_number: order.order_number,
      invoice_status: 'AUTHORISED'
    }

    VCR.use_cassette('sales_orders/query_by_id_and_match_with_credits', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert order.synced?
  end

  test "Can create multiple line items with same item" do
    order = create(:order, :sales_order, :submitted)

    product = create(:item, :product)

    order_item_1 = create(:order_item, item:product, order:order)
    order_item_2 = create(:order_item, item:product, order:order)

    order.mark_submitted!

    yaml_props = {
      order_number: order.order_number,
      order_status: 'AUTHORISED',
      order_total: order.total,
      order_items: order.order_items
    }

    VCR.use_cassette('sales_orders/query_not_found_create_with_items', erb: yaml_props) do
      SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert_equal(order.order_items[0].item, product, 'Should have matched the product')
    assert_equal(order.order_items[1].item, product, 'Should have matched the product')

    assert order.synced?
  end

end
