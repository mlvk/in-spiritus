class ItemsSyncer < BaseSyncer

  protected
    def find_record(xero_id)
      xero.Item.find(xero_id)
    end

    def find_record_by(model)
      xero.Item.first(:where => {:code => model.name})
    end

    def find_records(timestamp)
      xero.Item.all({:modified_since => timestamp})
    end

    def update_record(record, model)
      record.code = model.name
      record.description = model.description
    end

    def create_record
      xero.Item.build
    end

    def save_records(records)
      xero.Item.save_records(records)
    end

    def find_model(record)
      Item.find_by(xero_id:record.item_id) || Item.find_by(name:record.code)
    end

    def find_models
      Item.pending
    end

    def update_model(model, record)
      model.xero_id = record.item_id
      model.name = record.code
      model.description = record.description if record.description.present?

      model.save

      model.mark_synced!
    end
end
