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
    @model
      .route_visits
      .first
      .arrive_at
  end

  def end_time
    @model
      .route_visits
      .last
      .arrive_at
  end

  def drop_off_count
    @model
      .delivery_visits
      .count
  end

  def pick_up_count
    @model
      .pickup_visits
      .count
  end

  paginator  :offset
end
