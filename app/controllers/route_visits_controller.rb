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

  def process_visits
    authorize RouteVisit

    response = params['payload'].map {|route_visit_id, visit_data|
      process_route_visit(route_visit_id, visit_data)
    }

    render json: response, status: :ok
    # render json: params['payload'].map {|k, v| k}, status: :ok
  end

  def get_related_resource
    authorize RouteVisit
    super
  end

  def get_related_resources
    authorize RouteVisit
    super
  end

  private
    def process_route_visit (route_visit_id, visit_data)
      rv = RouteVisit.find(route_visit_id)
      client = rv.visit_window.client
      date = rv.route_plan.date

      create_item_levels(visit_data, client, date)
      create_credit(visit_data, client, date)
      fullfill_sales_orders(rv.sales_orders, visit_data)
      return route_visit_id
    end

    def fullfill_sales_orders (sales_orders, visit_data)
      sales_orders.each {|so|
        signature = Maybe(visit_data)[:salesOrders][so.id.to_s][:signature]
        so.signature = signature if signature.present?

        so.fullfilled = true
        so.save
      }
    end

    def create_credit (visit_data, client, date)
      if visit_data['items'].present?
        credit = Credit.new(client:client, date:date)
        visit_data['items'].each {|item_id, item_data|
          item = Item.find(item_id)

          credit.credit_items << CreditItem.new(
            credit:credit,
            item:item,
            quantity: item_data['returns'],
            unit_price: client.price_for_item(item))
        }

        credit.save
      end
    end

    def create_item_levels (visit_data, client, date)
      Item.all.each {|item|
        data = Maybe(visit_data)[:items][item.id.to_s].fetch({start:0, returns:0, total:0})
        create_item_level(date, client, item, data)
      }
    end

    def create_item_level (date, client, item, data)
      item_level = ItemLevel.new(
        user:current_user,
        start:data[:start],
        returns:data[:returns],
        client:client,
        item:item,
        day_of_week:date.cwday,
        taken_at:DateTime.now
      )

      total_delivered = SalesOrderItem.find_by_date_client_item(date, client, item)
        .reduce(0) {|acc, cur| acc + cur.quantity }

      item_level.total = Maybe(data)[:total].fetch(data[:start] + total_delivered - data[:returns])

      item_level.save
    end
end
