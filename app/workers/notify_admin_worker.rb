class NotifyAdminWorker
  include Sidekiq::Worker
  include MailUtils

  sidekiq_options :retry => false, unique: :until_executed

  def perform(date = Date.today)

    # Send route plan documents
    email_route_plan_documents date
  end

  private
  def email_route_plan_documents(date)
    return unless ENV['ADMIN_EMAILS'].present?

    route_plans = RoutePlan.where(:date => date)

    if route_plans.present?
      pdf_url = RoutePlanUtils.new.generate_packing_documents route_plans

      options = build_route_plan_message pdf_url
      send_email options
    end
  end

  def build_route_plan_message(pdf_url)
    date_fmt = Time.current.strftime('%d/%m/%y')

    recipients = ENV['ADMIN_EMAILS']
      .split(',')
      .map { |e| {:email => e} }

    context = {}

    {
      html: build_erb("route_plan.html", context),
      txt: build_erb("route_plan.txt", context),
      subject: "Route plan report - MLVK - #{date_fmt}",
      attachments: [pdf_url],
      recipients: recipients
    }
  end
end
