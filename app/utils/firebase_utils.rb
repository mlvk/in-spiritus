module FirebaseUtils
	def fb(uri = ENV['FIREBASE_URL'])
		@fb_client ||= Firebase::Client.new(uri)
  end

	def push_payload(key, payload)
		fb.update("", {key => payload})
	end

	def publish_fulfillment_documents(fulfillment, docs_url)
		key = "fulfillment_docs/#{fulfillment.id}"
		payload = {
			status: "published",
			pdf_url: docs_url
		}

		push_payload(key, payload)
	end

	def build_stock_level_data_point(stock_level)
		return unless stock.fulfillment.route_visit.completed_at.present?

		log("Crunching sales data for stock_level: #{stock_level.id}")

		stock = stock_level.stock
		fulfillment = stock.fulfillment
		order = fulfillment.order
		location = stock.location
		item = stock_level.item

		previous_stock_level = location.previous_stock_level(stock_level)
		previous_ending_level = [Maybe(previous_stock_level).ending_level.fetch(0), 0].max

		sold = [previous_ending_level - (stock_level.starting + stock_level.returns), 0].max

		timestamp = stock.fulfillment.route_visit.completed_at.to_i

		key = "locations/#{location.code}/#{item.code}/#{stock_level.id}"
		payload = {
			starting: [stock_level.starting, 0].max,
			returns: [stock_level.returns, 0].max,
			ending: stock_level.ending_level.to_i,
			previous_ending: previous_ending_level.to_i,
			sold: sold.to_i,
			ts: timestamp
		}

		push_payload(key, payload)
	end

	private
	def log(message)
    logger.info("[SalesDataCalc]: #{message}")
  end

  def logger
    @@sync_logger ||= Logger.new("#{Rails.root}/log/sales_data_calc.log")
  end
end
