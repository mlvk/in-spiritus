class BaseSyncer
  include XeroUtils
  include RedisUtils

  def sync_local
    process_local(find_models.take(5))
  rescue => e
    p e
    error e
  end

  def sync_remote(timestamp = fetch_last_remote_sync(self))
    start_timestamp = Time.current.to_s

    log("Staring remote sync since: #{start_timestamp}")
    changed_since_records = find_records(timestamp)
    log("Found the following record since timestamp: #{changed_since_records}")

    changed_since_records
      .each{|record|
        process_after_remote_sync(record, timestamp)
      }

    set_last_remote_sync(self, start_timestamp)
  end

  def sync_model_from_remote(model)
    record = find_record_by_id(model)

    if record.present?
      update_model(model, record)
      post_process_model(model)
    end
  end

  protected
  # Try to find a single xero record by its xero id
  def find_record(xero_id)
    raise_must_override
  end

  # Try to find a single record by some other predicate
  # Each record type may need a slightly different lookup
  def find_record_by(model)
    raise_must_override
  end

  # Query for a specific type of record using a predicate
  def find_records(predicate)
    raise_must_override
  end

  # Update a record based on the diff with the local model
  def update_record(record, model)
    raise_must_override
  end

  # Create a new xero record. This is called when the find_xero methods
  # return nil
  def create_record
    raise_must_override
  end

  # OPTIONAL - Update the local status code of the model to match what is in xero.
  # This is needed to avoid status changes that will later cause failure
  # when trying to sync. Example CreditNote:
  # 1. Local status: submitted
  # 2. Remote status: authorized
  #
  # This will be flagged for remote save, but will be updated with the local status
  # of submitted, which will fail xero sync
  def sync_local_model_status(model, record)
    true
  end

  # OPTIONAL - Check if this record should be included in the batch save
  # We need to somehow still update the model even if the record should not be
  # saved to xero. This is causing some items to not not archive or void
  # since they the remote server is already voided
  def should_save_record?(record, model)
    true
  end

  # Responsible for finding the local model for this record
  # It is up to the subclass to determine lookup logic
  # or to create a new model if none is found.
  # If nil is returned, the task won't attempt to process the record
  def find_model(record)
    raise_must_override
  end

  # Query local models based on last_updated timestamp
  def find_models
    raise_must_override
  end

  # Update the local model based on the record
  def update_model(model, record)
    raise_must_override
  end

  # Handle post process model
  def post_process_model(model)
    model.mark_synced!
  end

  # Batch save xero record
  def save_records(records)
    raise_must_override
  end

  def log(message)
    logger.info("[Syncer - Log]: #{message}")
  end

  def warn(message)
    logger.warn("[Syncer - Warning]: #{message}")
  end

  def error(e)
    if (e.respond_to? :message) && (e.respond_to? :backtrace)
      logger.error { "[Syncer - Error]: #{e.message} #{e.backtrace.join("\n")}" }
    else
      logger.error { "[Syncer - Error]: #{e}" }
    end
  end

  private
  def raise_must_override
    raise 'You must override this method in the concrete module'
  end

  def process_local(models)
    # We merge the model and record
    zipped = models.map(&method(:zip_model_record))

    # Filter only valid for save record. i.e. not voided, etc.
    marked_for_save = zipped.select {|o| o[:should_save] }

    # Update the xero record to the local model state
    marked_for_save.each {|o| update_record(o[:record], o[:model])}

    # Batch save to xero
    records_marked_for_save = marked_for_save.map {|o| o[:record]}
    save_records(records_marked_for_save)

    # Process all zipped, included voided etc, to the latest record state
    zipped.each {|o| process_after_local_sync(o[:record], o[:model]) }
  end

  def zip_model_record(model)
    record = find_or_create_record(model)
    sync_local_model_status(model, record)
    should_save = should_save_record?(record, model)

    { model:model, record:record, should_save: should_save }
  end

  def process_after_local_sync(record, model)
    if record.errors.present?
      record.errors.each{|e| error e}
    else
      update_model(model, record)
      post_process_model(model)
    end
  end

  def process_after_remote_sync(record, timestamp)
    model = find_model(record)

    if model.present?
      last_updated = record.respond_to?(:updated_date_utc) ? Maybe(record).updated_date_utc.to_time.fetch(timestamp) : timestamp
      if model.updated_at < last_updated
        log("#{model.class.to_s} - #{model.id} will be updated by remote sync")
        update_model(model, record)
        post_process_model(model)
      else
        log("#{model.class.to_s} - #{model.id} was updated after #{timestamp}. Therefor not processing")
      end
    end
  end

  private
  def logger
    @@sync_logger ||= Logger.new("#{Rails.root}/log/xero_sync.log")
  end

  def find_or_create_record(model)
    match = find_record_by_id(model) || find_record_by_other(model)
    if match.nil?
      log "Creating a new record instead since no match found on xero"
      return create_record
    else
      log "Found record for #{model}"
      return match
    end
  end

  def find_record_by_id(model)
    match = model.xero_id.present? ? find_record(model.xero_id) : nil
    if match.present?
      log "Found record by id for model: #{model}"
      return match
    end
  rescue => e
    log e.message
    nil
  end

  def find_record_by_other(model)
    match = find_record_by(model)
    if match.present?
      log "Found record by other means for model: #{model}"
      return match
    end
  rescue => e
    log e.message
    nil
  end
end
