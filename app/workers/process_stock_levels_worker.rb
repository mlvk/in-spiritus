class ProcessStockLevelsWorker
  include Sidekiq::Worker
  include FirebaseUtils

  sidekiq_options :retry => false, unique: :until_executed

  def perform
    StockLevel
      .tracked
      .each do |stock_level|
        build_stock_level_data_point stock_level

        stock_level.mark_processed!
      end
  end
end
