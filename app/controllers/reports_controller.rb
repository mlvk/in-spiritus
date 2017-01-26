class ReportsController < ApplicationJsonApiResourcesController
  include RedisUtils

  def customer_financials_by_range
    authorize :reports

    start_date, end_date = params.values_at(:start_date, :end_date)

    key = "reports-financial-all-#{start_date}-#{end_date}"

    data = redis.get(key)

    if data.nil?
      data = Company.customer.map{|c| c.financial_data_for_date_range(start_date, end_date)}.to_json
      redis.setex(key, 1.day.to_i, data)
    end

    render json: {report_data: JSON.parse(data)}
  end

  def product_financials_by_range
    authorize :reports

    start_date, end_date = params.values_at(:start_date, :end_date)

    key = "reports-product-financials-all-#{start_date}-#{end_date}"

    # data = redis.get(key)

    data = Item
      .product
      .active
      .map{|p| p.financial_data_for_date_range(start_date, end_date)}.to_json

    render json: {report_data: JSON.parse(data)}
  end
end
