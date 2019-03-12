require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  def setup
    prep_jr_headers
  end

  test "destroys a location and its association records" do
    sign_in_as_admin

    # Please note that create an ordering, it will create its credit_note, stock
    location = create(:location,
      order_count: 2,
      notification_rule_count: 2,
      visit_day_count: 2,
      item_desire_count: 2,
      item_credit_rate_count: 2)

    assert_differences([
      ['Location.count', -1],
      ['Order.count', -2],
      ['CreditNote.count', -2],
      ['Stock.count', -2],
      ['NotificationRule.count', -2],
      ['VisitDay.count', -2],
      ['ItemDesire.count', -2],
      ['ItemCreditRate.count', -2]]) do
     delete :destroy, params: { id: location }
    end
  end
end
