require 'test_helper'

class ProcessRouteVisitWorkerTest < ActiveSupport::TestCase

  test "Should generate notifications of fulfillments" do
    route_visit = create(:route_visit_with_fulfilled_fulfillments, :fulfilled)

    VCR.use_cassette('mail_gun/001') do
      ProcessRouteVisitWorker.new.perform
    end

    assert_equal(route_visit.fulfillments.first.notifications.pending.count, 1)
  end
end
