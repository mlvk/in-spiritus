module XeroUtils
	def logger
		@logger ||= Logger.new('log/xero.log', 'daily')
	end

	def xero
		@xero_client ||= Xeroizer::PrivateApplication.new(ENV['XERO_API_KEY'],
																		 ENV['XERO_SECRET'],
																		 '| echo "$XERO_PRIVATE_KEY" ',
																		 :rate_limit_sleep => 2,
																		 :logger => logger)
  end
end
