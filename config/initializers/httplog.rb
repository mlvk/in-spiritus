if Rails.env.development?
  HttpLog.options[:logger] = Logger.new('log/http.log', 'daily')
  HttpLog.options[:log_headers]   = true
end
