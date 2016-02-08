class RoutePlanResource < JSONAPI::Resource
  attributes :name,
             :template,
             :date

  has_one :user
  has_many :route_visits

  filter :date
  filter :template
  filter :user
  filter :id

  paginator :offset

end
