require 'test_helper'

class NotificationWorkerTest < ActiveSupport::TestCase

  test "Should send sales order notification when order is sales order and has order and wants order" do
    notification = create(:notification_with_sales_order)

    VCR.use_cassette('mail_gun/001') do
      NotificationWorker.new.perform
    end

    notification.reload
    assert notification.order.sales_order?
    assert notification.processed?
  end

  test "Should send purchase order notification when order is purchase order and has order and wants order" do
    notification = create(:notification_with_purchase_order)

    VCR.use_cassette('mail_gun/001') do
      NotificationWorker.new.perform
    end

    notification.reload
    assert notification.order.purchase_order?
    assert notification.processed?
  end

  test "Should not send notification when missing both order and credit note" do
    notification = create(:notification_invalid)

    worker = NotificationWorker.new

    process_notification_worker_spy = Spy.on(worker, :process)

    worker.perform

    refute process_notification_worker_spy.has_been_called?
  end

  test "Should not send notification when processed" do
    notification = create(:notification_with_sales_order, :processed)

    worker = NotificationWorker.new

    process_notification_worker_spy = Spy.on(worker, :process)

    worker.perform

    refute process_notification_worker_spy.has_been_called?
  end

end
