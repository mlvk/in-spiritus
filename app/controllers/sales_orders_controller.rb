class SalesOrdersController < ApplicationJsonApiResourcesController

  def stub_orders
    authorize SalesOrder

    delivery_date = Date.parse(params['deliveryDate'])
    allLocations = Location.scheduled_for_delivery_on(delivery_date.cwday)

    missingLocations = allLocations.select {|location| !location.has_sales_order_for_date?(delivery_date)}

    include_resources = ['sales_order_items', 'sales_order_items.item', 'location']
    serializer = JSONAPI::ResourceSerializer.new(SalesOrderResource, include: include_resources)

    resources = missingLocations.map { |location|
      so = SalesOrder.new(location:location, delivery_date:Date.today)
      c.item_desires.each do |item_desire|
        so.sales_order_items << SalesOrderItem.new(item:item_desire.item, quantity:0)
      end

      so.save
      SalesOrderResource.new(so, nil)
    }

    render json: serializer.serialize_to_hash(resources)
  end

  def index
    authorize SalesOrder
    super
  end

  def show
    authorize SalesOrder
    super
  end

  def create
    authorize SalesOrder
    super
  end

  def update
    authorize SalesOrder
    super
  end

  def get_related_resource
    authorize SalesOrder
    super
  end

  def get_related_resources
    authorize SalesOrder
    super
  end
end
