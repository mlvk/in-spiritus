require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
  end


  # @TODO: We should test that the UID for the companies are prefixed properly. These tests are brittle.
  # test "creates a unique item code without company initial when a company relationship is missing" do
  #   item = create(:item, code:nil, company:nil)
  #   assert_equal(item.code.size, 6)
  # end
  #
  # test "creates a unique item code with company initial when a company relationship is present" do
  #   company = create(:company)
  #   item = create(:item, code:nil)
  #   assert_equal(item.code.size, company.initials.size + 9)
  # end
end
