class SyncLocalCreditNotesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    CreditNotesSyncer.new.sync_local
  end
end
