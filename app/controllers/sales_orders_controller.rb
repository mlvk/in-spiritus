class SalesOrdersController < ApplicationJsonApiResourcesController

  def ping
    authorize SalesOrder

    render json: {data:[]}
  end

  def register_device_apn
    authorize SalesOrder
    
    url = "http://pubsub.pubnub.com/v1/push/sub-key/#{ENV['PN_SUB_KEY']}/devices/#{params['token']}?add=armen&type=apns"
    response = Unirest.get(url)

    render json: {data:url, status:response}
  end

  def stub_orders
    authorize SalesOrder

    delivery_date = Date.parse(params['deliveryDate'])
    allClients = Client.scheduled_for_delivery_on(delivery_date.cwday)

    missingClients = allClients.select {|c| !c.has_sales_order_for_date?(delivery_date)}

    include_resources = ['sales_order_items', 'sales_order_items.item', 'client']
    serializer = JSONAPI::ResourceSerializer.new(SalesOrderResource, include: include_resources)

    resources = missingClients.map { |c|
      so = SalesOrder.new(client:c, delivery_date:Date.today)
      c.client_item_desires.each do |cid|
        so.sales_order_items << SalesOrderItem.new(item:cid.item, quantity:0)
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
