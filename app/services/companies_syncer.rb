class CompaniesSyncer < BaseSyncer

  protected
    def find_record(xero_id)
      xero.Contact.find(xero_id)
    end

    def find_record_by(model)
      xero.Contact.first(:where => {:name => model.name})
    end

    def find_records(timestamp)
      xero.Contact.all({:modified_since => timestamp})
    end

    def update_record(record, model)
      record.name = model.name
    end

    def create_record
      xero.Contact.build
    end

    def save_records(records)
      xero.Contact.save_records(records)
    end

    def find_model(record)
      Company.find_by(xero_id:record.contact_id) || Company.find_by(name:record.name)
    end

    def find_models
      Company.pending
    end

    def update_model(model, record)
      model.xero_id = record.contact_id
      model.name = record.name
      model.save

      model.mark_synced!
    end
end
