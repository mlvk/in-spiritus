if Rails.env.development?
  HttpLog.configure do |config|
    config.logger = Logger.new('log/http.log', 'daily')
    config.log_headers = true
  end
end
