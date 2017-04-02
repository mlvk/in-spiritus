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

  test "counts lines correctly" do
    assert_equal(1, count_lines("Hello World"))
    assert_equal(2, count_lines("Hello \n World"))
    assert_equal(6, count_lines("Hello \n \n\n\n\nWorld"))
    assert_equal(9, count_lines("123456789", 1))
    assert_equal(0, count_lines(""))
    assert_equal(0, count_lines(nil))
    assert_equal(0, count_lines)
  end
end
