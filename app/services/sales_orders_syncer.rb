class SalesOrdersSyncer < BaseSyncer

  protected
  def find_record(xero_id)
    xero.Invoice.find(xero_id)
  end

  def find_record_by(model)
    xero.Invoice.find(model.order_number)
  end

  def find_records(timestamp)
    xero.Invoice.all({modified_since:timestamp, page:1})
  end

  def sync_local_model_status(model, record)
    model.sync_with_xero_status(record.status)
  end

  def should_save_record? (record, model)
    is_locally_invalid = !model.has_synced_with_xero? && model.deleted?
    is_remotely_unchangable = (record.status == 'VOIDED') ||
                          (record.status == 'DELETED') ||
                          (record.status == 'PAID') ||
                          (record.status == 'BILLED') ||
                          record.payments.present? ||
                          record.credit_notes.present?

    !is_locally_invalid && !is_remotely_unchangable
  end

  def update_record(record, model)
    record.invoice_number = model.order_number
    record.date = model.delivery_date
    record.due_date = model.due_date
    record.status = model.xero_status_code
    record.type = 'ACCREC'

    record.reference = model.location.full_name
    record.build_contact(contact_id:model.location.company.xero_id, name:model.location.company.name)

    create_record_line_items(record, model)
    create_record_shipping_line_item(record, model)
  end

  def create_record
    xero.Invoice.build
  end

  def save_records(records)
    xero.Invoice.save_records(records)
  end

  def find_model(record)
    Order.find_by(xero_id:record.invoice_id) || Order.find_by(order_number:record.invoice_number)
  end

  def find_models
    Order
      .sales_order
      .pending_sync
      .select { |o| o.is_valid? }
      .select { |o|
        is_past = (Time.current.to_date - o.delivery_date).to_i > 0
        !o.draft? || is_past
      }
  end

  def update_model(model, record)
    model.xero_id = record.invoice_id
    model.save

    model.sync_with_xero_status(record.status)
  end

  def post_process_model(model)
    model.mark_synced!
  end

  private
  def create_record_line_items(record, model)
    record.line_items.clear
    model
      .order_items
      .select { |oi| oi.has_quantity? }
      .each { |oi| create_record_line_item(record, oi) }
  end

  def create_record_line_item(record, order_item)
    if order_item.has_quantity?
      record.add_line_item(
        item_code:order_item.item.code,
        description:"#{order_item.item.name} - #{order_item.item.description}",
        quantity:order_item.quantity,
        unit_amount:order_item.unit_price,
        tax_type:'NONE',
        account_code: ENV['SALES_ACCOUNT_CODE'])
    end
  end

  def create_model_order_item(model, item)
    OrderItem.create(item:item, order:model)
  end

  def create_record_shipping_line_item(record, model)
    if model.has_shipping?
      record.add_line_item(
        description: 'Shipping',
        quantity: 1,
        unit_amount: model.shipping,
        tax_type: 'NONE',
        account_code:  (ENV['DISTRIBUTION_ACCOUNT_CODE'] || ENV['SALES_ACCOUNT_CODE']))
    end
  end
end
