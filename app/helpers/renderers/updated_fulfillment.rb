module Renderers
  class UpdatedFulfillment < BaseNotificationRenderer
    def build_message(notification)
      fulfillment = notification.fulfillment

      resources = [fulfillment.order, fulfillment.credit_note].select { |r| r.is_valid? }

      date_fmt = DateTime.now.strftime('%d/%m/%y')
      context = {
        fulfillment: fulfillment,
        notification_rule: notification.notification_rule
      }

      {
        html: build_erb("updated_fulfillment.html", context),
        txt: build_erb("updated_fulfillment.txt", context),
        subject: "Updated delivery documents - MLVK - #{fulfillment.id} - #{date_fmt}",
        attachments: [generate_pdfs(resources)]
      }
    end
  end
end
