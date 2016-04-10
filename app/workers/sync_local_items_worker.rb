class SyncLocalItemsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    ItemsSyncer.new.sync_local
  end
end
