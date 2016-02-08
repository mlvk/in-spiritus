class SessionsController < Devise::SessionsController

  skip_prepend_before_action :authenticate_user_from_token!, :only => :create

  def create
    self.resource = warden.authenticate!(auth_options)

    sign_in(resource_name, resource)

    data = {
      id: self.resource.id,
      token: self.resource.authentication_token,
      first_name: self.resource.first_name,
      last_name: self.resource.last_name,
      email: self.resource.email
    }

    render json: data, status: 201
  end
end
