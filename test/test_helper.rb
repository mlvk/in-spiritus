ENV['RAILS_ENV'] ||= 'test'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require File.expand_path('../../config/environment', __FILE__)
require File.expand_path('../helpers/auth_helpers', __FILE__)
require File.expand_path('../helpers/request_helpers', __FILE__)
require File.expand_path('../helpers/resource_helpers', __FILE__)

require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  include Helpers::AuthenicationHelpers
  include Helpers::RequestHelpers
  include Helpers::ResourceHelpers
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end
