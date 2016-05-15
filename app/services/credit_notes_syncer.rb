class CreditNotesSyncer < BaseSyncer

  protected
    def find_record(xero_id)
      xero.CreditNote.find(xero_id)
    end

    def find_record_by(model)
      xero.CreditNote.first(:where => {:credit_note_number => model.credit_note_number})
    end

    def find_records(timestamp)
      xero.CreditNote.all({:modified_since => timestamp})
    end

    def pre_flight_check(record, model)
      case record.status
      when 'DELETED'
        model.void!
      when 'VOIDED'
        model.void!
      end
    end

    def should_save_record? (record, model)
      !model.voided?
    end

    def update_record(record, model)
      record.credit_note_number = model.credit_note_number
      record.status = 'AUTHORISED'
      record.type = 'ACCRECCREDIT'
      record.reference = model.location.full_name

      record.build_contact(contact_id:model.location.company.xero_id, name:model.location.company.name)

      record.line_items.clear
      model
        .credit_note_items
        .select {|cni| cni.has_credit?}
        .each do | credit_note_item |
        create_record_line_item(record, credit_note_item)
      end
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
        .submitted
        .with_credit
    end

    def update_model(model, record)
      model.xero_id = record.credit_note_id

      if model.synced?
        record.line_items.each do |line_item|
          item = Item.find_by name: line_item.item_code
          credit_note_item = model.credit_note_items.find_by(item:item) || create_model_credit_note_item(model, line_item)
          credit_note_item.quantity = line_item.quantity
          credit_note_item.unit_price = line_item.unit_amount
          credit_note_item.save
        end

        # Clear missing credit_note_items
        model.credit_note_items.each do |credit_note_item|
          has_match = record.line_items.any? {|line_item| line_item.item_code == credit_note_item.item.name}
          credit_note_item.destroy if !has_match
        end
      end

      model.save

      model.mark_synced! if !model.voided?
    end

    private
      def create_record_line_item(record, credit_note_item)
        record.add_line_item(
          item_code:credit_note_item.item.name,
          description:credit_note_item.item.description,
          quantity:credit_note_item.quantity,
          unit_amount:credit_note_item.unit_price.round(2),
          tax_type:'NONE',
          account_code: '400')
      end

      def create_model_credit_note_item(model, line_item)
        item = Item.find_by name: line_item.item_code
        CreditNoteItem.create(item:item, credit_note:model)
      end
end
