class BaseSyncer
  include XeroUtils
  include RedisUtils

  # Sync from local to xero
  def sync_local
    process_local(find_models)
  end

  # Sync from xero to local
  def sync_remote(timestamp = fetch_last_remote_sync(self))
    start_timestamp = DateTime.now

    result = process_records(find_records(timestamp))

    if result
      set_last_remote_sync(self, start_timestamp)
    end

    return result
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

    # OPTIONAL - hook called before update_model or save_records is called.
    # A good place to void an item or change state of a local model based
    # on remote record state.
    def pre_flight_check(record, model)
      # Do nothing
    end

    # OPTIONAL - Check if this record should be deleted
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

    # Batch save xero record
    def save_records(records)
      raise_must_override
    end

    def log(message, level = 'info')
      Rails.logger.info("[Syncer - #{self.class} - #{level}]: #{message}")
    end

    def warn(message)
      log(message, 'warn')
    end

  private
    def raise_must_override
      raise 'You must override this method in the concrete module'
    end

    def process_local(models)
      records = models.map(&method(:prepare_record)).compact

      if records.present?
        if save_records(records)
          begin
            process_records(records)
          rescue => errors
            raise "Error processing records for #{self.class}: #{records}"
          end
        else
          raise "Error batch saving for #{self.class}: #{records}"
        end
      end
    end

    def prepare_record(model)
        record = _find_or_create_record(model)
        pre_flight_check(record, model)

        if should_save_record?(record, model)
          update_record(record, model)
          return record
        end
    end

    def process_records(records)
      records.map {|record|
        begin
          model = find_model(record)
          if model.present?
            pre_flight_check(record, model)
            update_model(model, record)
            record
          else
            nil
          end
        rescue => errors
          p "There was an error processing this record: #{errors}"
          nil
        end
      }.compact
    end

    def _find_or_create_record(model)
      _find_record_by_id_or_other(model) || create_record
    end

    def _find_record_by_id_or_other(model)
      record = nil
      if model.xero_id.present?
        begin
          record = find_record(model.xero_id)
        rescue => errors
          p "Error finding record by xero_id: #{errors}"
        end
      end

      if record.nil?
        begin
          record = find_record_by(model)
        rescue => errors
          p "Error finding record with that search criteria: #{errors}"
        end
      end

      return record
    end
end
