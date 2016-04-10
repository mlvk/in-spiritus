class SyncLocalCompaniesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    CompaniesSyncer.new.sync_local
  end
end
