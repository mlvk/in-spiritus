require 'test_helper'

class ProcessRouteVisitWorkerTest < ActiveSupport::TestCase

  test "Should send fulfilled and awaiting" do
    route_visit = create(:route_visit_with_fulfilled_fulfillments, :fulfilled)

    VCR.use_cassette('mail_gun/001') do
      ProcessRouteVisitWorker.new.perform
    end
  end

end
