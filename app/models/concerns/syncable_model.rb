module SyncableModel
  extend ActiveSupport::Concern

  included do
    include AASM

    after_save :mark_pending_sync!
    after_touch :mark_pending_sync!

    aasm :sync_state, :column => :sync_state, :skip_validation_on_save => true do
      state :pending_sync, :initial => true
      state :synced

      event :mark_pending_sync do
        transitions :from => [:pending_sync, :synced], :to => :pending_sync
      end

      event :mark_synced do
        transitions :from => [:pending_sync, :synced], :to => :synced
      end
    end

    enum sync_state: [ :pending_sync, :synced ]
  end
end
