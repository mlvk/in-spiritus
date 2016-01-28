class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :null_session
end
