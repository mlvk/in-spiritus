class SyncLocalSalesOrdersWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    SalesOrdersSyncer.new.sync_local
  end
end
