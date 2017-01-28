class RouteVisitsController < ApplicationJsonApiResourcesController
  def index
    authorize RouteVisit
    super
  end

  def show
    authorize RouteVisit
    super
  end

  def create
    authorize RouteVisit
    super
  end

  def update
    authorize RouteVisit
    super
  end

  def destroy
    authorize RouteVisit
    super
  end

  def get_related_resource
    authorize RouteVisit
    super
  end

  def get_related_resources
    authorize RouteVisit
    super
  end

  def submit
    authorize RouteVisit
    result = process_route_visit(params[:id], params[:data])

    if result[:success]
      render json: result, status: :ok
    else
      render json: result, status: :unprocessable_entity
    end
  end

  private
  def process_route_visit(route_visit_id, data)
    route_visit = RouteVisit.find(route_visit_id)

    fulfillments_data = Maybe(data[:fulfillments]).fetch([])

    ActiveRecord::Base.transaction do
      completed_at = data[:completed_at] || Time.current
      route_visit.completed_at = completed_at
      route_visit.save

      fulfillments_data.each do |fulfillment_data|
        process_fulfillment(fulfillment_data, route_visit, completed_at)
      end

      route_visit.mark_fulfilled!
    end

    {success:true, id:route_visit_id}
  rescue => error
    {success:false, error:"#{route_visit_id} - #{error.message}"}
  end

  def process_fulfillment(data, route_visit, completed_at)
    fulfillment = route_visit.fulfillments.find(data[:id])
    if fulfillment.nil?
      raise "Fulfillment with id #{data[:id]} not found on route_visit #{route_visit.id}"
    end

    process_order data[:order]
    process_credit_note data[:credit_note]
    process_stock(data[:stock], completed_at)
    process_pod data[:pod]

    fulfillment.mark_fulfilled!
  end

  def process_order(data)
    return if data.nil?

    order = Order.find(data[:id])

    order.order_items.each do |oi|
      oi.quantity = 0
      oi.unit_price = 0
      oi.save
    end

    order_items_data = Maybe(data[:order_items]).fetch([])

    order_items_data.each do |oid|
      item = Item.find(oid[:item_id])
      match = order.order_items.select {|oi|
        oi.id == oid[:id].to_s || oi.item.id.to_s == oid[:item_id]
      }.first

      target = match || OrderItem.create(
        order:order,
        item:item)

      target.unit_price = oid[:unit_price] || 0
      target.quantity = oid[:quantity] || 0

      target.save
    end

    order.mark_authorized! if order.can_transition_to?(:authorized)
    order.mark_pending_sync!
  end

  def process_credit_note(data)
    return if data.nil?

    credit_note = CreditNote.find(data[:id])

    credit_note.credit_note_items.each do |cni|
      cni.quantity = 0
      cni.unit_price = 0
      cni.save
    end

    credit_note_items_data = Maybe(data[:credit_note_items]).fetch([])

    credit_note_items_data.each do |cnid|
      item = Item.find(cnid[:item_id])
      match = credit_note.credit_note_items.select {|cni|
        cni.id == cnid[:id].to_s || cni.item.id.to_s == cnid[:item_id]
      }.first

      target = match || CreditNoteItem.create(
        credit_note:credit_note,
        item:item)

      target.unit_price = cnid[:unit_price] || 0
      target.quantity = cnid[:quantity] || 0

      target.save
    end

    credit_note.mark_submitted! unless credit_note.authorized? || credit_note.deleted?
    credit_note.mark_pending_sync!
  end

  def process_stock(data, completed_at)
    return if data.nil?

    stock = Stock.find(data[:id])
    stock.taken_at = completed_at

    stock.stock_levels.each do |sl|
      sl.starting = 0
      sl.returns = 0
      sl.save
    end

    stock.save

    stock_levels_data = Maybe(data[:stock_levels]).fetch([])

    stock_levels_data.each do |sld|
      item = Item.find(sld[:item_id])
      match = stock.stock_levels.select {|sl|
        sl.id == sld[:id].to_s || sl.item.id.to_s == sld[:item_id]
      }.first

      target = match || StockLevel.create(
        stock:stock,
        item:item)

      target.starting = sld[:starting] || 0
      target.returns = sld[:returns] || 0
      target.save

      target.mark_tracked!
    end
  end

  def process_pod(data)
    return if data.nil?

    pod = Pod.find(data[:id])

    pod.name = data[:name]
    pod.signature = data[:signature]
    pod.signed_at = data[:signed_at]

    pod.save
  end
end
