require 'test_helper'

class CompaniesSyncerTest < ActiveSupport::TestCase

  test "Should sync local record when they don't exist in xero" do
    company = Company.create(name:'Nature Well')

    VCR.use_cassette('contacts/001') do
      CompaniesSyncer.new.sync_local
    end

    company.reload

    assert company.xero_id.present?
  end

  test "Should sync local model (add xero_id) when matching code found" do
    company = Company.create(name:'Nature Well')

    VCR.use_cassette('contacts/002') do
      CompaniesSyncer.new.sync_remote(100.years.ago)
    end

    company.reload

    assert company.xero_id.present?, "Should have a xero_id"
  end

end
