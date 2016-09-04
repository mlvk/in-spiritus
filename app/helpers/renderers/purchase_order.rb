module Renderers
  class PurchaseOrder < BaseNotificationRenderer
    def build_message(notification)
      order = notification.order
      date_fmt = order.delivery_date.strftime('%d/%m/%y')
      context = {
        order: order,
        notification_rule: notification.notification_rule
      }

      {
        html: build_erb("purchase_order.html", context),
        txt: build_erb("purchase_order.txt", context),
        subject: "New Purchase Order - MLVK - #{order.order_number} - #{date_fmt}",
        attachments: [generate_pdfs(order)]
      }
    end
  end
end
