require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  def setup
    prep_jr_headers
  end

  # Index tests
  test "admin can view companies" do
    sign_in_as_admin

    get :index
    assert_response :success
  end

  test "drivers can view companies" do
    sign_in_as_driver

    get :index
    assert_response :success
  end

  test "accountants can view companies" do
    sign_in_as_accountant

    get :index
    assert_response :success
  end

  test "anonymous users can not view companies" do
    get :index
    assert_response :unauthorized
  end

  # Show tests
  test "admin can view a company" do
    company = create(:company)

    sign_in_as_admin

    get(:show, {id:company.id})

    assert_response :success
  end

  test "drivers can view a company" do
    company = create(:company)

    sign_in_as_driver

    get(:show, {id:Company.first.id})
    assert_response :success
  end

  test "accountants can view a company" do
    company = create(:company)

    sign_in_as_accountant

    get(:show, {id:Company.first.id})
    assert_response :success
  end

  test "anonymous users can not view a company" do
    company = create(:company)

    get(:show, {id:Company.first.id})
    assert_response :unauthorized
  end

  # Create
  test "admin can create companies" do
    sign_in_as_admin

    post :create, build_jr_hash(:company)
    assert_response :created
  end

  test "drivers can not create companies" do
    sign_in_as_driver

    post :create, build_jr_hash(:company)
    assert_response :unauthorized
  end

  test "accountants can not create companies" do
    sign_in_as_accountant

    post :create, build_jr_hash(:company)
    assert_response :unauthorized
  end

  test "pending users can not create companies" do
    sign_in_as_accountant

    post :create, build_jr_hash(:company)
    assert_response :unauthorized
  end

end
