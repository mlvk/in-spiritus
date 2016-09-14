require 'test_helper'

class StringUtilsTest < ActiveSupport::TestCase
  include StringUtils

  test "trims string when passed a string" do
    assert_equal('abc', trim('  abc  '))
  end

  test "not trim string when passed a trimmed string" do
    assert_equal('abc', trim('abc'))
  end

  test "returns nil when passed a nil" do
    assert_equal(nil, trim(nil))
  end

  test "trims and downcases when passed a string" do
    assert_equal('abc', trim_and_downcase('  AbC  '))
  end

  test "not trim and downcase when passed a trimmed and lowercase string" do
    assert_equal('abc', trim_and_downcase('abc'))
  end

  test "returns nil when passed a nil to trim_and_downcase function" do
    assert_equal(nil, trim_and_downcase(nil))
  end
end
