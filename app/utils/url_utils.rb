module UrlUtils
	def shorten_url(url)
    response = RestClient.post(
    "https://www.googleapis.com/urlshortener/v1/url?fields=id%2ClongUrl&key=#{ENV['GOOGLE_API_KEY']}",
    {longUrl:url}.to_json, content_type: :json, accept: :json)

    JSON.parse(response)["id"]
  end
end
