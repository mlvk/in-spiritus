class OrdersController < ApplicationJsonApiResourcesController

  def stub_orders
    authorize Order

    delivery_date = Date.parse(params['deliveryDate'])
    allLocations = Location.scheduled_for_delivery_on?(delivery_date.cwday)

    missingLocations = allLocations.select {|location| !location.has_sales_order_for_date?(delivery_date)}

    include_resources = ['order_items', 'order_items.item', 'location', 'location.company']
    serializer = JSONAPI::ResourceSerializer.new(OrderResource, include: include_resources)

    resources = missingLocations.map { |location|
      order = Order.new(location:location, delivery_date:delivery_date)
      location.item_desires.each do |item_desire|
        order.order_items << OrderItem.new(item:item_desire.item, quantity:0)
      end

      order.save
      OrderResource.new(order, nil)
    }

    render json: serializer.serialize_to_hash(resources)
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
    super
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
