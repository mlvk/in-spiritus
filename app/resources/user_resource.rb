class UserResource < JSONAPI::Resource
  attributes :email,
             :first_name,
             :last_name,
             :phone,
             :role,
             :password

  has_many   :route_plan_blueprints
end
