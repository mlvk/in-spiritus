class OrdersController < ApplicationJsonApiResourcesController
  include AwsUtils
  include PdfUtils

  def stub_orders
    authorize Order

    delivery_date = Date.parse(params['deliveryDate'])

    allLocations = Location
      .active
      .customer
      .with_valid_address
      .scheduled_for_delivery_on?(delivery_date)

    missingLocations = allLocations.select {|location| !location.has_sales_order_for_date?(delivery_date)}

    include_resources = ['order_items', 'order_items.item', 'location', 'location.company']
    serializer = JSONAPI::ResourceSerializer.new(OrderResource, include: include_resources)

    resources = missingLocations.map { |location|
      orders = build_orders_from_template(location, delivery_date)

      if orders.empty?
        order = Order.new(location:location, delivery_date:delivery_date, shipping:location.delivery_rate)
        location.item_desires.where(enabled:true).each do |item_desire|
          item_price = location.company.price_for_item(item_desire.item)
          order.order_items << OrderItem.new(item:item_desire.item, quantity:0, unit_price:item_price)
        end

        order.save
        OrderResource.new(order, nil)
      else
        orders.map {|order| OrderResource.new(order, nil)}
      end
    }

    render json: serializer.serialize_to_hash(resources.flatten)
  end

  def build_orders_from_template(location, delivery_date)
    location
      .order_templates
      .select {|order_template| order_template.valid_for_date?(delivery_date)}
      .map {|order_template| build_order_from_template(order_template, delivery_date)}
  end

  def build_order_from_template(order_template, delivery_date)
    location = order_template.location
    order = Order.new(location:location, delivery_date:delivery_date, shipping:location.delivery_rate)

    order_template.order_template_items.each do |oti|
      item_price = location.company.price_for_item(oti.item)
      order.order_items << OrderItem.new(item:oti.item, quantity:oti.quantity, unit_price:item_price)
    end

    order.save
    order.mark_published!
    order
  end

  def duplicate_sales_orders
    authorize Order

    is_valid = params['fromDate'].present? && params['toDate'].present?

    if is_valid
      from_date = Date.parse(params['fromDate'])
      to_date = Date.parse(params['toDate'])

      resources = Order
        .sales_order
        .where(delivery_date:from_date)
        .has_active_location
        .each { |so|
          so.clone(to_date: to_date)
        }

      render json: { status: true }
    else
      render json: { status: false, message: "Request not valid" }
    end
  end

  def generate_pdf
    orders = Order.where(order_number: params['orders'])

    orders.each do |order|
      authorize order
    end

    pdf_url = generate_and_upload_pdfs orders

    render json: {url:pdf_url}
  end

  def index
    authorize Order
    super
  end

  def show
    authorize Order
    super
  end

  def create
    authorize Order
    super
  end

  def update
    authorize Order
    super
  end

  def destroy
    authorize Order

    order = Order.find(params['id'])

    if order.has_synced_with_xero?
      if order.voided? || order.authorized?
        order.mark_voided!
      else
        order.mark_deleted!
      end

      order.mark_pending_sync!

      render json: { status: true }
    else
      super
    end
  end

  def get_related_resource
    authorize Order
    super
  end

  def get_related_resources
    authorize Order
    super
  end
end
