class ItemsSyncer < BaseSyncer

  protected
    def find_record(xero_id)
      xero.Item.find(xero_id)
    end

    def find_record_by(model)
      xero.Item.first(:where => {:code => model.code})
    end

    def find_records(timestamp)
      xero.Item.all({:modified_since => timestamp})
    end

    def update_record(record, model)
      record.name = model.name
      record.code = model.code
      record.description = model.description
      record.purchase_details = {unit_price:model.default_price}
    end

    def create_record
      xero.Item.build
    end

    def save_records(records)
      xero.Item.save_records(records)
    end

    def find_model(record)
      Item.find_by(xero_id:record.item_id) || Item.find_by(code:record.code)
    end

    def find_models
      Item.pending
    end

    def update_model(model, record)
      model.xero_id = record.item_id
      model.name = Maybe(record).name.fetch(model.name)
      model.code = Maybe(record).code.fetch(model.code)
      model.description = Maybe(record).description.fetch(model.description)
      model.default_price = Maybe(record).purchase_details.unit_price.fetch(model.default_price)

      model.save!

      model.mark_synced!
    end
end
