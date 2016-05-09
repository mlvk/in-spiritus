class ProcessRouteVisitWorker
  include Sidekiq::Worker
  include MailGunUtils
  include PdfUtils

  sidekiq_options :retry => false, unique: :until_executed

  def perform
    # SalesOrdersSyncer.new.sync_local
    # CreditNotesSyncer.new.sync_local

    # Process CCs

    # Send notifications
    RouteVisit
      .fulfilled
      .each do |rv|
        process_route_visit rv
      end

  end

  def process_route_visit(route_visit)
    route_visit
      .fulfillments
      .select {|fulfillment| fulfillment.fulfilled? }
      .each do |fulfillment|
        process_fulfillment fulfillment
      end

    route_visit.mark_processed!
  end

  def process_fulfillment(fulfillment)
    send_fulfillment_notifications fulfillment

    fulfillment.mark_processed!
  end

  def send_fulfillment_notifications(fulfillment)
    location = fulfillment.order.location

    if fulfillment.awaiting?
      location.notification_rules.each do |rule|
        mb_obj = build_notification_for_fulfillment(fulfillment, rule)
        send_message mb_obj
      end

      fulfillment.mark_notified!
    end
  end

  def build_notification_for_fulfillment(fulfillment, rule)
    html = ERB.new(File.open('app/views/emails/delivery_confirmation.html.erb').read).result(binding)
    txt = ERB.new(File.open('app/views/emails/delivery_confirmation.txt.erb').read).result(binding)
    date_fmt = fulfillment.order.delivery_date.strftime('%d/%m/%y')

    mb_obj = Mailgun::MessageBuilder.new
    mb_obj.from(ENV['SALES_FROM_EMAIL'], {"first"=>"Aram", "last" => "Zadikian"})
    mb_obj.add_recipient(:to, rule.email, {"first"=>rule.first_name, "last" => rule.last_name || ""})
    mb_obj.subject("Delivery Confirmation - MLVK - #{date_fmt}")
    mb_obj.body_html(html)
    mb_obj.body_text(txt)
    add_invoice_attachment(fulfillment, mb_obj)
    add_credit_note_attachment(fulfillment, mb_obj)

    return mb_obj
  end

  def add_credit_note_attachment(fulfillment, mb_obj)
    if fulfillment.credit_note.present?
      credit_note_date_fmt = fulfillment.credit_note.date.strftime('%d/%m/%y')
      temp_credit_note_file_url = generate_temp_credit_notes_pdf [fulfillment.credit_note]
      mb_obj.add_attachment(temp_credit_note_file_url, "Credit - #{fulfillment.credit_note.credit_note_number} - #{credit_note_date_fmt}.pdf")
    end
  end

  def add_invoice_attachment(fulfillment, mb_obj)
    if fulfillment.order.present?
      order_date_fmt = fulfillment.order.delivery_date.strftime('%d/%m/%y')
      temp_invoice_file_url = generate_temp_orders_pdf [fulfillment.order]
      mb_obj.add_attachment(temp_invoice_file_url, "Invoice - #{fulfillment.order.order_number} - #{order_date_fmt}.pdf")
    end
  end

end
