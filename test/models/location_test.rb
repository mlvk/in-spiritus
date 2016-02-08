require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @location = locations(:wu_staten)
  end

  test "can view price_tier" do
    refute_empty @location.address.address, "Should not be empty!!!"
  end
end
