class ProcessFulfillmentsWorker
  include Sidekiq::Worker
  include MailGunUtils
  include PdfUtils

  sidekiq_options :retry => false, unique: :until_executed

  def perform
    SalesOrdersSyncer.new.sync_local
    CreditNotesSyncer.new.sync_local

    # Process CCs

    # Send notifications
    Fulfillment
      .fulfilled
      .awaiting_notification
      .each do |f|

        if f.location.notification_rules.present?

          order_date_fmt = f.order.delivery_date.strftime('%d/%m/%y')
          credit_note_date_fmt = f.credit_note.date.strftime('%d/%m/%y')
          temp_invoice_file_url = generate_temp_orders_pdf [f.order]
          temp_credit_note_file_url = generate_temp_credit_notes_pdf [f.credit_note] if f.credit_note.has_credit?

          f.location.notification_rules.each do |rule|
            html = ERB.new(File.open('app/views/emails/delivery_confirmation.html.erb').read).result(binding)
            txt = ERB.new(File.open('app/views/emails/delivery_confirmation.txt.erb').read).result(binding)

            mb_obj = Mailgun::MessageBuilder.new
            mb_obj.from(ENV['SALES_FROM_EMAIL'], {"first"=>"Aram", "last" => "Zadikian"})
            mb_obj.add_recipient(:to, rule.email, {"first"=>rule.first_name, "last" => rule.last_name || ""})
            mb_obj.subject("Delivery Confirmation - MLVK - #{order_date_fmt}")
            mb_obj.body_html(html)
            mb_obj.body_text(txt)
            mb_obj.add_attachment(temp_invoice_file_url, "Invoice - #{f.order.order_number} - #{order_date_fmt}.pdf")
            mb_obj.add_attachment(temp_credit_note_file_url, "Credit - #{f.credit_note.credit_note_number} - #{credit_note_date_fmt}.pdf") if temp_credit_note_file_url.present?
            send_message mb_obj
          end

          File.delete(temp_invoice_file_url)
          File.delete(temp_credit_note_file_url) if temp_credit_note_file_url.present?
        end

        f.mark_notified!
      end
  end
end
