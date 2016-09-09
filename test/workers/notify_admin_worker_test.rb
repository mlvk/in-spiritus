require 'test_helper'

class NotifyAdminWorkerTest < ActiveSupport::TestCase

  test "Should email admins when existed route plans today" do
    create(:route_plan, date: Date.today)

    worker = NotifyAdminWorker.new

    process_notification_worker_spy = Spy.on(worker, :send_email)

    VCR.use_cassette('mail_gun/001') do
      worker.perform
    end

    assert process_notification_worker_spy.has_been_called?
  end

  test "Should note email admins when not exist route plans today" do
    create(:route_plan, date: Date.yesterday)

    worker = NotifyAdminWorker.new

    process_notification_worker_spy = Spy.on(worker, :send_email)

    VCR.use_cassette('mail_gun/001') do
      worker.perform
    end

    refute process_notification_worker_spy.has_been_called?
  end
end
