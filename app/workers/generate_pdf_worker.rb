class GeneratePdfWorker
  include Sidekiq::Worker
  include AwsUtils
  include FirebaseUtils

  def perform(order_id)
    order = Order.find(order_id)

    if order.present?
      pdf = Pdf::Invoice.new :orders => [order]

      url = upload_file(key: "#{order.order_number}.pdf", body:pdf.render)

      fb.update("pdfs", { order.order_number => url })
    end
  end
end
