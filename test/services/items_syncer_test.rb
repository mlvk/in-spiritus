require 'test_helper'

class ItemsSyncerTest < ActiveSupport::TestCase

  # Local sync testing
  test "Should sync local item when they don't exist in xero" do
    Item.create(name:'Sunseed Chorizo')

    VCR.use_cassette('items/001') do
      ItemsSyncer.new.sync_local
    end

    assert Item.first.xero_id.present?
  end

  test "Should sync local item when record exists in xero" do
    new_name = 'Sunseed Chorizo - Changed'
    Item.create(name:new_name, xero_id:'b3d9696b-13f3-455a-aac9-c5b26e9b71ea')

    result = nil
    VCR.use_cassette('items/003') do
      result = ItemsSyncer.new.sync_local
    end

    assert_equal(result.first.code, new_name)
  end

  # Remote sync testing
  test "Should update local item with xero_id when item name matches remote item" do
    Item.create(name:'Sunseed Chorizo')

    VCR.use_cassette('items/002') do
      ItemsSyncer.new.sync_remote(10.minutes.ago)
    end

    assert Item.first.xero_id.present?
  end

end
