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

  def generate_temp_orders_pdf(orders)
    pdf = Pdf::Invoice.new :orders => orders

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
