module PdfUtils
	include AwsUtils

  def generate_and_upload_orders_pdf(orders)
    pdf = Pdf::Invoice.new :orders => orders

    key = "#{SecureRandom.hex}.pdf"

    upload_file(key: key, body:pdf.render)
  end

  def generate_temp_orders_pdf(orders)
    pdf = Pdf::Invoice.new :orders => orders

    local_url = "public/#{SecureRandom.hex}.pdf"

    pdf.render_file local_url

    return local_url
  end
end
