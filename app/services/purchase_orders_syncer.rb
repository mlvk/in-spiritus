class PurchaseOrdersSyncer < BaseSyncer

  protected
    def find_record(xero_id)
      xero.PurchaseOrder.find(xero_id)
    end

    def find_record_by(model)
      xero.PurchaseOrder.find(model.order_number)
    end

    def find_records(timestamp)
      xero.PurchaseOrder.all({:modified_since => timestamp})
    end

    def should_save_record? (record, model)
      model.submitted?
    end

    def update_record(record, model)
      record.purchase_order_number = model.order_number
      record.date = model.delivery_date
      record.delivery_date = model.delivery_date
      record.status = 'AUTHORISED'

      record.reference = model.location.full_name
      record.build_contact(contact_id:model.location.company.xero_id, name:model.location.company.name)

      record.line_items.clear
      model.order_items.each do | order_item |
        create_record_line_item(record, order_item)
      end
    end

    def create_record
      xero.PurchaseOrder.build
    end

    def save_records(records)
      xero.PurchaseOrder.save_records(records)
    end

    def find_model(record)
      Order
        .purchase_order
        .find_by(xero_id:record.purchase_order_id) ||
      Order
        .purchase_order
        .find_by(order_number:record.purchase_order_number)
    end

    def find_models
      Order
        .purchase_order
        .submitted
    end

    def update_model(model, record)
      model.xero_id = record.purchase_order_id

      record.line_items.each do |line_item|
        item = Item.find_by(code: line_item.item_code)
        if item.present?
          order_item = model.order_items.find_by(item:item) || create_model_order_item(model, item)
          order_item.quantity = line_item.quantity
          order_item.unit_price = line_item.unit_amount
          order_item.save
        end
      end

      # Clear missing order_items
      model.order_items.each do |order_item|
        has_match = record.line_items.any? {|line_item| line_item.item_code == order_item.item.code}
        order_item.destroy if !has_match
      end

      model.save

      model.mark_synced! if !model.voided?
    end

    private
    def create_record_line_item(record, order_item)
      if order_item.has_quantity?
        record.add_line_item(
          item_code:order_item.item.code,
          description:order_item.item.description,
          quantity:order_item.quantity,
          unit_amount:order_item.unit_price,
          tax_type:'NONE',
          account_code: ENV['COGS_ACCOUNT_CODE'])
      end
    end

    def create_model_order_item(model, item)
      OrderItem.create(item:item, order:model)
    end
end
