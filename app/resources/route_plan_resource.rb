class RoutePlanResource < JSONAPI::Resource
  attributes :date

  has_one    :user
  has_many   :route_visits

  filter     :date
  filter     :user
  filter     :id

  paginator  :offset
end
