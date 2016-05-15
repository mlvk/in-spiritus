class RoutePlanResource < JSONAPI::Resource
  attributes :date,
             :published_state

  has_one    :user
  has_many   :route_visits

  filters    :date,
             :user,
             :published_state,
             :id

  paginator  :offset
end
