class ApplicationJsonApiResourcesController < JSONAPI::ResourceController
  include Pundit

  prepend_before_action :authenticate_user_from_token!
  after_action :verify_authorized

  protect_from_forgery with: :null_session

  rescue_from Pundit::NotAuthorizedError, with: :pundit_authorization_failed

  # This allows us to access the current user from JR resources
  def context
    {current_user: current_user}
  end

  private
    def authenticate_user_from_token!
      use_dummy_session

      authenticate_with_http_token do |token, options|
        user_email = options[:email].presence
        user       = user_email && User.find_by_email(user_email)

        token.slice! "token=\""

        if user && Devise.secure_compare(user.authentication_token, token)
          sign_in user, store: false
          @current_user = user
        end
      end

      # Hack this until simple auth is fixed
      # @current_user = User.first if @current_user.nil?

      render_unauthorized! "Valid user required to make that request" if @current_user.nil?
    end

    def use_dummy_session
      return unless request.format.xml? || request.format.json?
      env["rack.session.id"] = 1000 # used to avoid generate_sid()
      env["rack.session.options"][:drop] = true
    end

    def pundit_authorization_failed(exception)
      policy = exception.policy.class.to_s.underscore
      query = exception.query
      user_email = @current_user.email
      render_unauthorized! "Unauthorized. #{user_email} tried to run #{query} on the #{policy}"
    end

    def render_unauthorized!(message)
      render json: {message:message}, status: :unauthorized
    end
end
