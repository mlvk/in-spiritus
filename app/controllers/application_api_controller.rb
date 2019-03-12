class ApplicationApiController < ActionController::Base
  include Pundit

  before_action :authenticate_user_from_token!
  after_action :verify_authorized

  protect_from_forgery with: :null_session, prepend: true

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def authenticate_user_from_token!
      use_dummy_session

      authenticate_with_http_token do |token, options|
        user_email = options[:email].presence
        user       = user_email && User.find_by_email(user_email)

        token.slice! "token=\""

        if user && Devise.secure_compare(user.authentication_token, token)
          sign_in user, store: false
        end
      end
    end

    def use_dummy_session
      return unless request.format.xml? || request.format.json?
      env["rack.session.id"] = 1000 # used to avoid generate_sid()
      env["rack.session.options"][:drop] = true
    end

    def user_not_authorized
      render json: {}, status: :unauthorized
    end

end
