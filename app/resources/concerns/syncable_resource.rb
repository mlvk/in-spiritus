module SyncableResource
  extend ActiveSupport::Concern

  included do
    attributes :sync_state

    filter     :sync_state
  end
end
