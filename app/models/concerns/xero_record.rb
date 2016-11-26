module XeroRecord
  extend ActiveSupport::Concern

  def has_synced_with_xero?
    xero_id.present?
  end
end
