class EmailPurchaseOrdersWorker
  include Sidekiq::Worker
  include MailGunUtils

  sidekiq_options :retry => true, unique: :until_executed

  def perform
    orders = Order
      .purchase_order
      .awaiting_notification

    orders.each do |order|
      email_new_purchase_order order
      order.mark_notified!
    end

  end
end
