class ProcessRouteVisitWorker
  include Sidekiq::Worker
  include AwsUtils
  include PdfUtils
  include FirebaseUtils
  include UrlUtils

  sidekiq_options :retry => false, unique: :until_executed

  def perform
    RouteVisit
      .fulfilled
      .each(&method(:process_route_visit))
  end

  def process_route_visit(route_visit)
    driver = Maybe(route_visit).route_plan.user._

    route_visit
      .fulfillments
      .belongs_to_sales_order
      .each do |f|
        build_notifications f
        publish_documents f

        if driver != Nothing
          msg = "#{driver.name} - #{f.to_string}"
          Log.notify_distribution_event(msg)
        end
    end

    route_visit.mark_processed!
  end

  private
  def build_notifications(f)
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

  def publish_documents(f)
    key = "fulfillment_docs/#{f.id}"
		payload = {
			status: "processing"
		}

    push_payload(key, payload)

    records = [f.order, f.credit_note].select {|r| r.is_valid?}
    url = generate_and_upload_pdfs(records)

    publish_fulfillment_documents(f, shorten_url(url))
  end
end
