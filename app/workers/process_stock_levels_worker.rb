class ProcessStockLevelsWorker
  include Sidekiq::Worker
  include FirebaseUtils

  sidekiq_options :retry => false, unique: :until_executed

  def perform
    StockLevel
      .tracked
      .select {|sl| sl.stock.fulfillment.route_visit.present? }
      .each do |sl|
        build_stock_level_data_point sl

        sl.mark_processed!
      end
  end
end
