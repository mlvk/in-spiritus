class UpdatedFulfillment < BaseNotificationRenderer
  def build_message(notification)
    fulfillment = notification.fulfillment
    date_fmt = DateTime.now.strftime('%d/%m/%y')
    context = {
      fulfillment: fulfillment,
      notification_rule: notification.notification_rule
    }

    {
      html: build_erb("updated_fulfillment_notification.html", context),
      txt: build_erb("updated_fulfillment_notification.txt", context),
      subject: "New updated fulfillment test - MLVK - #{fulfillment.id} - #{date_fmt}",
      attachments: [generate_pdfs([fulfillment.order, fulfillment.credit_note])]
    }
  end
end
