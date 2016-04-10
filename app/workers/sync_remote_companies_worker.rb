class SyncRemoteCompaniesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    CompaniesSyncer.new.sync_remote
  end
end
