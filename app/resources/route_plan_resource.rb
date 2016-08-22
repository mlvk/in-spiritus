class RoutePlanResource < JSONAPI::Resource
  attributes :date,
             :published_state,
             :start_time,
             :end_time,
             :drop_off_count,
             :pick_up_count

  has_one    :user
  has_many   :route_visits

  filters    :date,
             :user,
             :published_state,
             :id

  def start_time
    360
  end

  def end_time
    660
  end

  def drop_off_count
    20
  end

  def pick_up_count
    10
  end

  paginator  :offset
end
