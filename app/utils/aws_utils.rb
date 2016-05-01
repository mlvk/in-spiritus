module AwsUtils
	def s3
		@s3_client ||= Aws::S3::Client.new
  end

	def upload_file(key: nil, body: nil)
		raise "Must add a file to upload" if key.nil? || body.nil?

		s3.put_object(bucket: ENV['PDF_BUCKET'], key: key, body: body)

		return "https://s3.amazonaws.com/#{ENV['PDF_BUCKET']}/#{key}"
	end
end
