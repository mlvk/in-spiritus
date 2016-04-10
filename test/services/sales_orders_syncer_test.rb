require 'test_helper'

class SalesOrdersSyncerTest < ActiveSupport::TestCase

  # Local sync testing
  test "Remote deleted invoices should update to deleted locally" do

    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    order = Order.create(order_type:'sales-order', location:location, delivery_date:Date.parse('2016-03-01'))
    order.order_number = 'voided-invoice'
    order.save

    Item.all.each do |item|
      OrderItem.create(item:item, quantity:5, unit_price:5, order:order)
    end

    order.mark_fulfilled!

    result = nil
    VCR.use_cassette('sales_orders/002') do
      result = SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert order.voided?
  end

  test "Valid local sales orders should be created in xero" do

    Item.create(name:'Sunseed Chorizo', xero_id:'b3d9696b-13f3-455a-aac9-c5b26e9b71ea')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    order = Order.create(order_type:'sales-order', location:location, delivery_date:Date.parse('2016-03-01'))
    order.order_number = 'valid-new-invoice'
    order.save

    Item.all.each do |item|
      OrderItem.create(item:item, quantity:5, unit_price:5, order:order)
    end

    refute order.fulfilled?
    order.mark_fulfilled!
    assert order.fulfilled?

    VCR.use_cassette('sales_orders/003') do
      SalesOrdersSyncer.new.sync_local
    end

    order.reload

    assert order.xero_id.present?, 'Xero id not present'
    assert order.synced?, 'order was not marked as synced'
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

    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    order = Order.create(order_type:'sales-order', location:location, delivery_date:Date.parse('2016-03-01'))
    order.order_number = 'remote-voided-invoice-number'
    order.xero_id = 'remote-voided-invoice-id'
    order.save

    Item.all.each do |item|
      OrderItem.create(item:item, quantity:5, unit_price:5, order:order)
    end

    order.mark_fulfilled!

    VCR.use_cassette('sales_orders/005') do
      SalesOrdersSyncer.new.sync_remote
    end

    order.reload

    assert order.voided?, 'Order was not voided when remote syncing'
  end

  test "should update a local order when remote local are out of sync and local model is in state synced" do

    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    order = Order.create(order_type:'sales-order', location:location, delivery_date:Date.parse('2016-03-01'))
    order.order_number = 'updated-remote-invoice-number'
    order.xero_id = 'updated-remote-invoice-id'
    order.save

    Item.all.each do |item|
      OrderItem.create(item:item, quantity:5, unit_price:5, order:order)
    end

    order.mark_fulfilled!
    order.mark_synced!

    VCR.use_cassette('sales_orders/006') do
      SalesOrdersSyncer.new.sync_remote(10.minutes.ago)
    end

    order.reload

    assert order.order_items.all? {|order_item| order_item.quantity == 6}, 'Order item quantities did not match'
  end

  test "should remove order item if missing from remote record and local model is synced?" do
    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    order = Order.create(order_type:'sales-order', location:location, delivery_date:Date.parse('2016-03-01'))
    order.order_number = 'remote-invoice-with-removed-order-item-number'
    order.xero_id = 'remote-invoice-with-removed-order-item-id'
    order.save

    Item.all.each do |item|
      OrderItem.create(item:item, quantity:5, unit_price:5, order:order)
    end

    order.mark_fulfilled!
    order.mark_synced!

    VCR.use_cassette('sales_orders/007') do
      SalesOrdersSyncer.new.sync_remote(10.minutes.ago)
    end

    order.reload

    assert order.order_items.empty?, 'Order items found when expected none'
  end

end
