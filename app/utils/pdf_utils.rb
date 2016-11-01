module PdfUtils
	include AwsUtils

	def generate_pdfs(records)
		pdf = build_pdf records

		# For Testing Only
		# local_url = 'public/testing.pdf'

		# For production
		local_url = "tmp/pdfs/#{SecureRandom.hex}.pdf"

		pdf.render_file local_url

    return local_url
	end

	def generate_and_upload_pdfs(records)
		pdf = build_pdf records
		key = "#{SecureRandom.hex}.pdf"
		path = "tmp/pdfs/#{key}"
		pdf.render_file path
		s3_data = upload_file(key, path)
		File.delete(path)
		return s3_data
	end

	def build_pdf(records)
		collection = (records.respond_to? :each) ? records : [records]
		Pdf::ContainerPdf.new :conversions => collection.map {|r| {data:r, renderer:r.renderer}}
	end
end
