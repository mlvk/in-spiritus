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
    Maybe(@model)
      .route_visits
      .first
      .arrive_at
      ._
  end

  def end_time
    Maybe(@model)
      .route_visits
      .last
      .arrive_at
      ._
  end

  def drop_off_count
    Maybe(@model)
      .delivery_visits
      .count
      ._
  end

  def pick_up_count
    Maybe(@model)
      .pickup_visits
      .count
      ._
  end

  paginator  :offset
end
