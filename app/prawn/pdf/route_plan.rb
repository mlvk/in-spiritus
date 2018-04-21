module Pdf
  class RoutePlan
    include Pdf::Elements

    def initialize(route_plan, pdf)
      header(route_plan, pdf)
      line_item_table(build_route_visit_rows(route_plan), pdf)

      # pdf.start_new_page

      # header(route_plan, pdf)
      # line_item_table(build_item_information_rows(route_plan), pdf)
    end

    def header(route_plan, pdf)
      start_y = 720
      col1 = 0
      col2 = 100

      pdf.bounding_box([0, start_y], :width => 540, :height => 50) do
        y = pdf.cursor
        pdf.formatted_text_box [{ text: "Route Plan: ", styles: [:bold] }], :at => [col1, y]

        label = "#{route_plan.user.name} - #{route_plan.date.strftime('%A, %m/%d/%y')}"

        pdf.formatted_text_box [{ text: label }], :at => [col2, y]
        pdf.image "app/assets/images/flower.png", :at => [510, y+10], :width => 20
      end

    end

    def build_route_visit_rows(route_plan)
      route_plan
        .route_visits
        .distinct
        .select(&:is_valid?)
        .sort {|x,y| x.position <=> y.position}
        .each_with_index
        .map {|route_visit, index|
          location = route_visit.fulfillments.first.order.location
          company = location.company
          address_label = location.address.to_s
          location_label = route_visit.has_multiple_fulfillments? ? "Multiple orders" : "#{location.code} - #{location.name}"
          [
            {x:5,   label:"#",        width:30,  align: :left,  content:{ text: "#{index + 1}.", size: 8}},
            {x:40,  label:"COMPANY",  width:120, align: :left, content:{ text: company.name, size: 11}},
            {x:190, label:"LOCATION", width:200, align: :left,  content:{ text: location_label, size: 11}},
            {x:390, label:"ADDRESS",  width:200, align: :left,  content:{ text: address_label, size: 9}}
          ]
        }
    end

    def build_item_information_rows(route_plan)
      route_plan
        .route_visits
        .distinct
        .sort {|x,y| x.position <=> y.position}
        .flat_map(&:fulfillments)
        .flat_map(&:order)
        .select(&:sales_order?)
        .select(&:has_quantity?)
        .flat_map(&:order_items)
        .select(&:has_quantity?)
        .reduce({}) {|acc, cur|
          item = cur.item
          prev_data = acc[item.id] || {qty:0, item:item}
          prev_data[:qty] = prev_data[:qty] + cur.quantity
          acc[item.id] = prev_data
          acc
        }
        .map {|kv_pair| kv_pair[1]}
        .sort {|x,y| Maybe(x[:item].position).fetch(10000) <=> Maybe(y[:item].position).fetch(10000)}
        .each_with_index
        .map{|obj, index|
          [
            {x:5,     label:"#",      width:30,  align: :left, content:{ text: "#{index + 1}.", size: 8, styles: [:italic]}},
            {x:10,    label:"QTY",    width:30,  align: :right, content:{ text: obj[:qty].to_s, size: 11}},
            {x:60,    label:"CODE",   width:70,  align: :left,  content:{ text: obj[:item].code, size: 11, styles: [:italic]}},
            {x:140,   label:"NAME",   width:110, align: :left,  content:{ text: obj[:item].name, size: 9}},
            {x:270,   label:"DESC",   width:190, align: :left,  content:{ text: Maybe(obj[:item].description).fetch("").truncate(121), size: 7}},
          ]
        }

      end
  end
end
