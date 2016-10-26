require 'test_helper'

class RouteVisitTest < ActiveSupport::TestCase
  test "renders to_string correctly" do
    company = create(:company)
    location = create(:location, company:company)
    order = create(:order, location:location)
    fulfillment = create(:fulfillment, order:order)
    route_visit = create(:route_visit, fulfillments:[fulfillment])

    expected_string = "#{company.name} - #{location.code} - #{location.name}"
    assert_equal(expected_string, route_visit.to_string)
  end

end
