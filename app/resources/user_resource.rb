class UserResource < JSONAPI::Resource
  attributes :email,
             :first_name,
             :last_name,
             :phone,
             :role

  has_many   :route_plan_blueprints
end
