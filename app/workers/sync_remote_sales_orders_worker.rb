class SyncRemoteSalesOrdersWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    SalesOrdersSyncer.new.sync_remote
  end
end
