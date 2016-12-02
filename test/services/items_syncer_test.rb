require 'test_helper'

class ItemsSyncerTest < ActiveSupport::TestCase

  # Local sync testing
  test "Should sync local item when they don't exist in xero" do
    item = create(:item)

    yaml_props = {
      item_code: item.code,
      item_id: 'new_xero_id'
    }

    VCR.use_cassette('items/001', erb: yaml_props) do
      ItemsSyncer.new.sync_local
    end

    assert_equal(yaml_props[:item_id], Item.first.xero_id)
  end

  test "Sync local item attributes when record exists in xero" do
    item = create(:item, :synced, :with_xero_id)

    yaml_props = {
      item_id: item.xero_id,
      code: item.code,
      name: item.name,
      description: item.description,
    }

    item.code = yaml_props[:code_changed]
    item.name = yaml_props[:new_name]
    item.description = yaml_props[:description_changed]
    item.save

    item.mark_pending_sync!

    VCR.use_cassette('items/003', erb: yaml_props) do
      ItemsSyncer.new.sync_local
    end

    assert_equal("#{yaml_props[:name]}", Item.first.name)
    assert_equal("#{yaml_props[:code]}", Item.first.code)
    assert_equal("#{yaml_props[:description]}", Item.first.description)
  end

  # Remote sync testing
  test "Should update local item with xero_id when item name matches remote item" do
    item = create(:item)

    yaml_props = {
      item_id: 'new_item_id',
      code: item.code
    }

    VCR.use_cassette('items/002', erb: yaml_props) do
      ItemsSyncer.new.sync_remote(10.minutes.from_now)
    end

    assert_equal(yaml_props[:item_id], Item.first.xero_id)
  end

end
