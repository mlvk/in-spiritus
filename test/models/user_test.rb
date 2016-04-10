require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  end

  test "set_admin_role sets to admin role" do
    user = create(:user)
    assert user.pending?

    user.set_admin_role!
    assert user.admin?
  end
end
