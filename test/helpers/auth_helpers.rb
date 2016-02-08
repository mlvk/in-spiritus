module Helpers
  module AuthenicationHelpers
    def sign_in_as_admin
      @request.headers["Authorization"] = 'Token token="admin_token", email="ts@wutang.com"'
    end

    def sign_in_as_driver
      @request.headers["Authorization"] = 'Token token="driver_token", email="mm@wutang.com"'
    end

    def sign_in_as_accountant
      @request.headers["Authorization"] = 'Token token="accountant_token", email="id@wutang.com"'
    end
  end
end
