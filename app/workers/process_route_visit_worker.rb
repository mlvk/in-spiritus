class ProcessRouteVisitWorker
  include Sidekiq::Worker
  include MailGunUtils
  include PdfUtils

  sidekiq_options :retry => false, unique: :until_executed

  def perform
    RouteVisit
      .fulfilled
      .each(&method(:process_route_visit))
  end

  def process_route_visit(route_visit)
    route_visit
      .fulfillments
      .fulfilled
      .each(&method(:process_fulfillment))

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
        send_notification_for_fulfillment(fulfillment, rule)
      end

      fulfillment.mark_notified!
    end
  end

  def send_notification_for_fulfillment(fulfillment, rule)
    if fulfillment.order.sales_order?
      send_sales_order_fulfillment_notification(fulfillment, rule)
    else
      send_purchase_order_fulfillment_notification(fulfillment, rule)
    end
  end

  def send_sales_order_fulfillment_notification(fulfillment, rule)
    html = ERB.new(File.open('app/views/emails/sales_order_delivery_confirmation.html.erb').read).result(binding)
    txt = ERB.new(File.open('app/views/emails/sales_order_delivery_confirmation.txt.erb').read).result(binding)
    date_fmt = fulfillment.order.delivery_date.strftime('%d/%m/%y')

    mb_obj = Mailgun::MessageBuilder.new
    mb_obj.from(ENV['SALES_FROM_EMAIL'], {"first"=>"Aram", "last" => "Zadikian"})
    mb_obj.add_recipient(:to, rule.email, {"first"=>rule.first_name, "last" => rule.last_name || ""})
    mb_obj.subject("Delivery Confirmation - MLVK - #{date_fmt}")
    mb_obj.body_html(html)
    mb_obj.body_text(txt)
    attach_orders_pdf(fulfillment.order, mb_obj)
    add_credit_note_attachment(fulfillment.credit_note, mb_obj) if Maybe(fulfillment).credit_note.has_credit?.fetch(false)

    send_message mb_obj
  end

  def send_purchase_order_fulfillment_notification(fulfillment, rule)
    html = ERB.new(File.open('app/views/emails/purchase_order_delivery_confirmation.html.erb').read).result(binding)
    txt = ERB.new(File.open('app/views/emails/purchase_order_delivery_confirmation.txt.erb').read).result(binding)
    date_fmt = fulfillment.order.delivery_date.strftime('%d/%m/%y')

    mb_obj = Mailgun::MessageBuilder.new
    mb_obj.from(ENV['SALES_FROM_EMAIL'], {"first"=>"Aram", "last" => "Zadikian"})
    mb_obj.add_recipient(:to, rule.email, {"first"=>rule.first_name, "last" => rule.last_name || ""})
    mb_obj.subject("Pickup Confirmation - MLVK - #{date_fmt}")
    mb_obj.body_html(html)
    mb_obj.body_text(txt)
    attach_orders_pdf(fulfillment.order, mb_obj)

    send_message mb_obj
  end

  def add_credit_note_attachment(credit_note, mb_obj)
    if credit_note.present?
      credit_note_date_fmt = credit_note.date.strftime('%d/%m/%y')
      mb_obj.add_attachment(generate_pdfs(credit_note), "Credit - #{credit_note.credit_note_number} - #{credit_note_date_fmt}.pdf")
    end
  end

  def attach_orders_pdf(order, mb_obj)
    if order.present?
      order_date_fmt = order.delivery_date.strftime('%d/%m/%y')
      if(order.sales_order?)
        mb_obj.add_attachment(generate_pdfs(order), "Invoice - #{order.order_number} - #{order_date_fmt}.pdf")
      else
        mb_obj.add_attachment(generate_pdfs(order), "Purchase Order - #{order.order_number} - #{order_date_fmt}.pdf")
      end
    end
  end

end
