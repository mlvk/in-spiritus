module Helpers
  module AuthenicationHelpers
    def sign_in_as_admin
      user = create(:user, :admin)
      @request.headers["Authorization"] = "Token token=\"#{user.authentication_token}\", email=\"#{user.email}\""
    end

    def sign_in_as_driver
      user = create(:user, :driver)
      @request.headers["Authorization"] = "Token token=\"#{user.authentication_token}\", email=\"#{user.email}\""
    end

    def sign_in_as_accountant
      user = create(:user, :accountant)
      @request.headers["Authorization"] = "Token token=\"#{user.authentication_token}\", email=\"#{user.email}\""
    end
  end
end
