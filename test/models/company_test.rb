require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test "generates a location_code_prefix when one not present on save" do
    company = build(:company)
    assert company.location_code_prefix.nil?

    company.save

    assert company.location_code_prefix.present?
  end

  test "generates a location_code_prefix when one not present on create" do
    company = create(:company)
    assert company.location_code_prefix.present?
  end

  test "does not generate a location_code_prefix if one is present" do
    company = create(:company, location_code_prefix:'prefix')
    assert company.location_code_prefix.present?

    company.save

    assert_equal(company.location_code_prefix, 'prefix')
  end

  test "should downcase location_code_prefix" do
    company1 = create(:company, location_code_prefix:'Prefix')
    assert_equal(company1.location_code_prefix, 'prefix')

    company2 = create(:company)
    assert_equal(company2.location_code_prefix, company2.location_code_prefix.downcase)
  end
end
