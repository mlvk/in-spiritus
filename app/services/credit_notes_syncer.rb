class CreditNotesSyncer < BaseSyncer

  protected
    def find_record(xero_id)
      xero.CreditNote.find(xero_id)
    end

    def find_record_by(model)
      xero.CreditNote.find(model.credit_note_number)
    end

    def find_records(timestamp)
      xero.CreditNote.all({modified_since:timestamp, page:1})
    end

    def sync_local_model_status(model, record)
      model.sync_with_xero_status(record.status)
    end

    def should_save_record? (record, model)
      is_locally_invalid = !model.has_synced_with_xero? && model.deleted?
      is_remotely_unchangable = (record.status == 'VOIDED') ||
                            (record.status == 'DELETED') ||
                            (record.status == 'PAID') ||
                            (record.status == 'BILLED')

      !is_locally_invalid && !is_remotely_unchangable
    end

    def update_record(record, model)
      record.credit_note_number = model.credit_note_number
      record.status = model.xero_status_code
      record.type = 'ACCRECCREDIT'
      record.reference = model.location.full_name

      record.build_contact(contact_id:model.location.company.xero_id, name:model.location.company.name)

      create_record_line_items(record, model)
    end

    def create_record
      xero.CreditNote.build
    end

    def save_records(records)
      xero.CreditNote.save_records(records)
    end

    def find_model(record)
      CreditNote.find_by(xero_id:record.credit_note_id) || CreditNote.find_by(credit_note_number:record.credit_note_number)
    end

    def find_models
      CreditNote
        .pending_sync
        .select { |cn| !cn.draft? }
    end

    def update_model(model, record)
      model.xero_id = record.credit_note_id
      model.credit_note_number = record.credit_note_number
      model.save

      # record.line_items.each do |line_item|
      #   item = Item.find_by(code:line_item.item_code)
      #
      #   if item.present?
      #     credit_note_item = model.credit_note_items.find_by(item:item) || CreditNoteItem.create(credit_note:model, item:item)
      #     credit_note_item.quantity = line_item.quantity
      #     credit_note_item.unit_price = line_item.unit_amount
      #     credit_note_item.save
      #   end
      # end
      #
      # # Clear missing credit_note_items
      # model.credit_note_items.each do |credit_note_item|
      #   has_match = record.line_items.any? {|line_item| line_item.item_code == credit_note_item.item.code}
      #   credit_note_item.destroy if !has_match
      # end

      model.sync_with_xero_status(record.status)
    end

    def post_process_model(model)
      model.mark_synced!
    end

    private
    def create_record_line_items(record, model)
      record.line_items.clear

      valid_rows = model
        .credit_note_items
        .select {|cni| cni.has_credit? }

      if valid_rows.empty?
        create_default_record_line_item(record)
      else
        valid_rows.each { |cni| create_record_line_item(record, cni) }
      end
    end

    def create_record_line_item(record, credit_note_item)
      record.add_line_item(
        item_code:credit_note_item.item.code,
        description:"#{credit_note_item.item.name} - #{credit_note_item.item.description}",
        quantity:credit_note_item.quantity,
        unit_amount:credit_note_item.unit_price.round(2),
        tax_type:'NONE',
        account_code: ENV['SPOILAGE_ACCOUNT_CODE'] || '400')
    end

    def create_default_record_line_item(record)
      record.add_line_item(
        description:"Empty Credit",
        quantity:0,
        unit_amount:0,
        tax_type:'NONE',
        account_code: ENV['SPOILAGE_ACCOUNT_CODE'] || '400')
    end
end
