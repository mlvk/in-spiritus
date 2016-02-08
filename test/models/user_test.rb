require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # @user = locations(:wu_staten)
  end

  test "set_admin_role sets to admin role" do
    user = create(:user)
    assert user.pending?

    user.set_admin_role!
    assert user.admin?
  end
end
