class SyncRemoteCreditNotesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    CreditNotesSyncer.new.sync_remote
  end
end
