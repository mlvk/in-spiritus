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

  def should_save_record?(record, model)
    record.contact_status != Company::ARCHIVED_STATUS
  end

  def update_record(record, model)
    record.name = model.name
    record.contact_status = model.active? ? Company::ACTIVE_STATUS : Company::ARCHIVED_STATUS
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
    Company.pending_sync
  end

  def update_model(model, record)
    model.xero_id = record.contact_id
    model.name = record.name

    model.save

    case record.contact_status
    when Company::ARCHIVED_STATUS
      model.mark_archived!
    else
      model.mark_active!
    end
  end

  def post_process_model(model)
    model.mark_synced!
  end
end
