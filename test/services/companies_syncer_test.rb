require 'test_helper'

class CompaniesSyncerTest < ActiveSupport::TestCase

  test "Should sync local record when they don't exist in xero" do
    company = create(:company, name:'Nature Well')

    yaml_props = {
      remote_contact_id: 'new_contact_id'
    }

    VCR.use_cassette('contacts/001', erb: yaml_props) do
      CompaniesSyncer.new.sync_local
    end

    company.reload

    assert_equal(yaml_props[:remote_contact_id], company.xero_id, "Xero id did not match")
  end

  test "Should sync local model (add xero_id) when matching name found" do
    company = create(:company, name:'Nature Well')

    VCR.use_cassette('contacts/002') do
      CompaniesSyncer.new.sync_remote(100.years.ago)
    end

    company.reload

    assert company.xero_id.present?, "Should have a xero_id"
  end

end
