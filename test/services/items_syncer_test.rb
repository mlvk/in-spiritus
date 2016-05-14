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
    item = create(:item, :synced)

    yaml_props = {
      item_id: item.xero_id,
      code: item.code,
      name: item.name,
      description: item.description,

      code_changed: 'new_code',
      name_changed: 'new_name',
      description_changed: 'new_description'
    }

    item.name = yaml_props[:new_name]
    item.save

    item.mark_pending!

    VCR.use_cassette('items/003', erb: yaml_props) do
      ItemsSyncer.new.sync_local
    end

    assert_equal("#{yaml_props[:name_changed]}FORCE", Item.first.name)
    assert_equal("#{yaml_props[:code_changed]}FORCE", Item.first.code)
    assert_equal("#{yaml_props[:description_changed]}FORCE", Item.first.description)
  end

  # Remote sync testing
  test "Should update local item with xero_id when item name matches remote item" do
    item = create(:item)

    yaml_props = {
      item_id: 'new_item_id',
      code: item.code
    }

    VCR.use_cassette('items/002', erb: yaml_props) do
      ItemsSyncer.new.sync_remote(10.minutes.ago)
    end

    assert_equal(yaml_props[:item_id], Item.first.xero_id)
  end

end
