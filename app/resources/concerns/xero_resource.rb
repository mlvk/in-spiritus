module XeroResource
  extend ActiveSupport::Concern

  included do
    attributes :xero_id
  end
end
