module AwsUtils
	def s3
		@s3_client ||= Aws::S3::Client.new(:logger => Logger.new("log/aws.log"), :http_wire_trace => true)
  end

	def upload_file(key, path)
		raise "Must add a file to upload" if key.nil? || path.nil?

		s3.put_object({
			bucket: ENV['PDF_BUCKET'],
			key: key,
			body: File.read(path)
		})

		return "https://s3.amazonaws.com/#{ENV['PDF_BUCKET']}/#{key}"
	end
end
