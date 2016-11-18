module Renderers
  class Fulfillment < BaseNotificationRenderer
    def build_message(notification)
      fulfillment = notification.fulfillment

      resources = [fulfillment.order, fulfillment.credit_note].select { |r| r.is_valid? }

      date_fmt = Time.current.strftime('%d/%m/%y')
      context = {
        fulfillment: fulfillment,
        notification_rule: notification.notification_rule
      }

      {
        html: build_erb("fulfillment.html", context),
        txt: build_erb("fulfillment.txt", context),
        subject: "Order delivered - MLVK - #{fulfillment.id} - #{date_fmt}",
        attachments: [generate_pdfs(resources)]
      }
    end
  end
end
