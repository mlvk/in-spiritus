class UserResource < JSONAPI::Resource
  attributes :email,
             :first_name,
             :last_name,
             :phone,
             :role
end
