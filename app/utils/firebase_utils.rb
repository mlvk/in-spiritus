module FirebaseUtils
	def fb(uri = 'https://in-spiritus.firebaseio.com/')
		@fb_client ||= Firebase::Client.new(uri)
  end
end
