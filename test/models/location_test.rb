require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
  end

  test "can view price_tier" do
    refute_empty @location.address.street, "Should not be empty!!!"
  end
end
