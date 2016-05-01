class ProcessStockLevelsWorker
  include Sidekiq::Worker
  include FirebaseUtils
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    StockLevel
      .where(tracking_state:StockLevel.tracking_states[:tracked])
      .each do |stock_level|

        key = "locations/#{stock_level.stock.location.code}/#{stock_level.item.name}"

        data = {
          key => {
            quantity: stock_level.starting,
            returns: stock_level.returns,
            timestamp: Firebase::ServerValue::TIMESTAMP
          }
        }

        fb.update('', data)

        stock_level.mark_processed!
      end
  end
end
