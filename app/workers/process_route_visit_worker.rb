class ProcessRouteVisitWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false, unique: :until_executed

  def perform
    RouteVisit
      .fulfilled
      .each(&method(:process_route_visit))
  end

  def process_route_visit(route_visit)
    route_visit.fulfillments.each do |f|
      if !f.has_pending_notification? && f.is_valid?
        renderer = f.never_notified? ? "Fulfillment" : "UpdatedFulfillment"

        f.location.notification_rules.each do |nr|
          Notification.create(
            fulfillment:f,
            renderer:renderer,
            notification_rule:nr)
        end
      end
    end

    route_visit.mark_processed!
  end
end
