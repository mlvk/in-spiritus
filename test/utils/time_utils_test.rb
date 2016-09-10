require 'test_helper'

class TimeUtilsTest < ActiveSupport::TestCase
  test "raise error when passed param is not a Integer" do
    assert_raises('minutes is not a number') do
      TimeUtils.minutes_to_formatted 'eee'
    end
  end

  test "formats to hours and minutes when passed minutes" do
    assert_equal('02:30', TimeUtils.minutes_to_formatted(2 * 60 + 30))
  end
end
