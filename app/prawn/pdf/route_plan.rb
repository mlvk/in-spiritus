module Pdf
  class RoutePlan

    def guide_y(y = @pdf.cursor)
      @pdf.stroke_axis(:at => [0, y], :height => 0, :step_length => 20, :negative_axes_length => 5, :color => '0000FF')
    end

    def initialize(route_plan, pdf)
      @route_plan = route_plan
      @pdf = pdf
      # @pdf.stroke_axis

      header(720, route_plan)
      body(680, route_plan)

      # start_new_page if cursor < 175

      # footer
    end

    def header(start_y, route_plan)
      col1 = 10
      col2 = 100

      @pdf.bounding_box([0, start_y], :width => 540, :height => 120) do
        y = @pdf.cursor
        @pdf.formatted_text_box [{ text: "Route Plan: ", styles: [:bold] }], :at => [col1, y]

        label = "#{route_plan.user.name} - #{route_plan.date.strftime('%A, %m/%d/%y')}"

        @pdf.formatted_text_box [{ text: label }], :at => [col2, y]
        @pdf.image "app/assets/images/flower.png", :at => [510, y+10], :width => 20
      end

      # guide_y
    end

    def body(start_y, route_plan)
      @pdf.move_cursor_to start_y

      @pdf.move_down 5
      route_plan
        .route_visits
        .sort {|x,y| x.position <=> y.position}
        .each_with_index do |route_visit, index|
          route_visit_row(route_visit, index)
        end
    end


    def route_visit_row(route_visit, index)
      y = @pdf.cursor
      height = 17
      col1 = -10
      col2 = 30
      col3 = 140
      col4 = 270
      col5 = 500

      @pdf.line_width = 0.5
      # dash(8, :space => 20, :phase => 5)
      @pdf.transparent(0.5) { @pdf.stroke_horizontal_line 0, 540, :at => y + 2 }

      @pdf.bounding_box([col1, y], :width => 20, :height => height) do
       @pdf.formatted_text_box [{ text: "#{index + 1}.", size: 8, styles: [:italic]}], :align => :right, :valign => :center
      end

      @pdf.bounding_box([col2, y], :width => 100, :height => height) do
        label = route_visit.fulfillments.first.order.location.company.name
        @pdf.formatted_text_box [{ text: label, size: 11}], :align => :left, :valign => :center
      end

      @pdf.bounding_box([col3, y], :width => 200, :height => height) do
        location_id = route_visit.fulfillments.first.order.location.id
        location_name = route_visit.fulfillments.first.order.location.name
        label = route_visit.has_multiple? ? 'Multiple orders' : "#{location_id} - #{location_name}"
        @pdf.formatted_text_box [{ text: label, size: 9}], :align => :left, :valign => :center
      end

      @pdf.bounding_box([col4, y], :width => 200, :height => height) do
        street = route_visit.address.street.titleize
        zip = route_visit.address.zip.titleize
        label = "#{street}, #{zip}"
        @pdf.formatted_text_box [{ text: label, size: 9}], :align => :left, :valign => :center
      end

      if route_visit.has_pickup?
        @pdf.image "app/assets/images/ic_local_shipping_black_24dp_2x.png", :at => [514, y-2], :width => 15
      end

      if route_visit.has_multiple?
        y = @pdf.cursor + 4
        route_visit
          .fulfillments
          .flat_map(&:order)
          .select(&:has_quantity?)
          .each_with_index do |order, i|
          @pdf.bounding_box([col3, y], :width => 300, :height => height) do
            location_id = order.location.id
            location_name = order.location.name
            label = "#{location_id} - #{location_name}"
            @pdf.formatted_text_box [{ text: label, size: 8}], :align => :left, :valign => :center
          end
          y = @pdf.cursor + 5
        end

      end



      # @pdf.bounding_box([60, y], :width => 100, :height => height) do
      #  @pdf.formatted_text_box [{ text: order_item.item.name, size: 9}], :align => :left, :valign => :center
      # end
      #
      # @pdf.bounding_box([170, y], :width => 290, :height => height) do
      #   desc = Maybe(order_item).item.description._.truncate(61)
      #   @pdf.formatted_text_box [{ text: desc, size: 9}], :align => :left, :valign => :center
      # end
      #
      # @pdf.bounding_box([450, y], :width => 35, :height => height) do
      #  @pdf.formatted_text_box [{ text: order_item.unit_price.to_s, size: 9}], :align => :right, :valign => :center
      # end
      #
      # @pdf.bounding_box([500, y], :width => 35, :height => height) do
      #  @pdf.formatted_text_box [{ text: order_item.total.to_s, size: 9}], :align => :right, :valign => :center
      # end

      @pdf.move_down 4

      @pdf.start_new_page if @pdf.cursor < 0
    end

  end
end
