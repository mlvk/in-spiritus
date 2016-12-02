require 'test_helper'

class CompaniesSyncerTest < ActiveSupport::TestCase

  test "Should sync local record when they don't exist in xero" do
    company = create(:company, name:'Nature Well 1')

    yaml_props = {
      contact_id: 'new_remote_id',
      contact_name: company.name
    }

    VCR.use_cassette('contacts/query_remote_then_create', erb: yaml_props, :match_requests_on => [:host]) do
      CompaniesSyncer.new.sync_local
    end

    company.reload

    assert_equal(yaml_props[:contact_id], company.xero_id, "Xero id did not match")
  end

  test "Remote archived companies should update to archived locally" do
    company = create(:company, :with_xero_id)

    yaml_props = {
      id: company.xero_id,
      name: company.name,
      status: 'ARCHIVED'
    }

    VCR.use_cassette('contacts/query_remote_return_match', erb: yaml_props, :match_requests_on => [:host]) do
      CompaniesSyncer.new.sync_local
    end

    company.reload

    assert company.archived?, "Should have become archived"
  end

  test "Should sync local model (add xero_id) when matching name found" do
    company = create(:company, name:'Nature Well 4')

    yaml_props = {
      contact_name: company.name,
      contact_id: "already_existing_on_remote_id"
    }

    VCR.use_cassette('contacts/get_last_since', erb: yaml_props) do
      CompaniesSyncer.new.sync_remote(10.minutes.from_now)
    end

    company.reload

    assert_equal(company.xero_id, yaml_props[:contact_id], "remote xero id did not match")
  end

end
