module Renderers
  class UpdatedPurchaseOrder < BaseNotificationRenderer
    def build_message(notification)
      order = notification.order
      date_fmt = order.delivery_date.strftime('%d/%m/%y')
      context = {
        order: order,
        notification_rule: notification.notification_rule
      }

      {
        html: build_erb("updated_purchase_order.html", context),
        txt: build_erb("updated_purchase_order.txt", context),
        subject: "Updated Purchase Order - MLVK - #{order.order_number} - #{date_fmt}",
        attachments: [generate_pdfs(order)]
      }
    end
  end
end
