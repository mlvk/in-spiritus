module PdfUtils
	include AwsUtils

  def generate_and_upload_orders_pdf(orders)
    pdf = Pdf::Invoice.new :orders => orders

    key = "#{SecureRandom.hex}.pdf"

    upload_file(key: key, body:pdf.render)
  end

	def generate_and_upload_credit_notes_pdf(credit_notes)
    pdf = Pdf::CreditNote.new :credit_notes => credit_notes

    key = "#{SecureRandom.hex}.pdf"

    upload_file(key: key, body:pdf.render)
  end

	def generate_and_upload_route_plans_pdf(route_plans)
		orders = route_plans
			.flat_map {|rp| rp.route_visits}
			.sort {|x,y| y.position <=> x.position}
			.flat_map {|rv| rv.fulfillments}
			.flat_map {|f| f.order}

		pdf = Pdf::Invoice.new :orders => orders

    key = "#{SecureRandom.hex}.pdf"

    upload_file(key: key, body:pdf.render)
	end

  def convert_orders_to_pdfs(orders)
		sales_orders_pdf = Pdf::Invoice.new :orders => orders.select(&:sales_order?)
		purchase_orders_pdf = Pdf::PurchaseOrder.new :orders => orders.select(&:purchase_order?)

    sales_orders_url = "tmp/pdfs/#{SecureRandom.hex}.pdf"
		purchase_orders_url = "tmp/pdfs/#{SecureRandom.hex}.pdf"

    sales_orders_pdf.render_file sales_orders_url if sales_orders_pdf.present?
		purchase_orders_pdf.render_file purchase_orders_url if purchase_orders_pdf.present?

    return {:sales_orders_url => sales_orders_url, :purchase_orders_url => purchase_orders_url}
  end

	def generate_purchase_order_pdf(orders)
    pdf = Pdf::PurchaseOrder.new :orders => orders

    local_url = "tmp/pdfs/#{SecureRandom.hex}.pdf"

    pdf.render_file local_url

    return local_url
  end

	def generate_temp_credit_notes_pdf(credit_notes)
    pdf = Pdf::CreditNote.new :credit_notes => credit_notes

    local_url = "tmp/pdfs/#{SecureRandom.hex}.pdf"

    pdf.render_file local_url

    return local_url
  end
end
