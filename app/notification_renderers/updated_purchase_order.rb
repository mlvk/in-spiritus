class UpdatedPurchaseOrder < BaseNotificationRenderer
  def build_message(notification)
    order = notification.order
    date_fmt = order.delivery_date.strftime('%d/%m/%y')
    context = {
      order: order
    }

    {
      html: build_erb("updated_purchase_order_notification.html", context),
      txt: build_erb("updated_purchase_order_notification.txt", context),
      subject: "Updated Purchase Order - MLVK - #{order.order_number} - #{date_fmt}",
      attachments: [generate_pdfs(order)]
    }
  end
end
