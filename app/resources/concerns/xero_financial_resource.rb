module XeroFinancialResource
  extend ActiveSupport::Concern

  included do
    VALID_STATES = [0, 1, 2, 3, 4]
    
    attributes :xero_financial_record_state

    filter :status, default: 'valid', apply: ->(records, value, _options) {
      case value.first
      when "valid"
        records
          .where("xero_financial_record_state = any (array#{VALID_STATES})")
          .distinct
      when "all"
        records
      else
        raise "Status is not valid, use either valid or all"
      end
    }
  end
end
