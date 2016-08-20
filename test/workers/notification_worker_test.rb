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

  test "Should send credit note notification when has credit note and wants credit" do
    notification = create(:notification_with_credit_note)

    VCR.use_cassette('mail_gun/001') do
      NotificationWorker.new.perform
    end

    notification.reload
    assert notification.processed?
  end

  test "Should not send notification when has not order and credit note" do
    notification = create(:notification)

    VCR.use_cassette('mail_gun/001') do
      NotificationWorker.new.perform
    end

    notification.reload
    assert notification.processed?
  end

  test "Should not send notification when processed" do
    notification = create(:notification, :processed)

    VCR.use_cassette('mail_gun/001') do
      NotificationWorker.new.perform
    end

    notification.reload
    assert notification.processed?
  end

end
