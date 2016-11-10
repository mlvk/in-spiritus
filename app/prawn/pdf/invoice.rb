module Pdf
  class Invoice

    def guide_y(y = @pdf.cursor)
      @pdf.stroke_axis(:at => [0, y], :height => 0, :step_length => 20, :negative_axes_length => 5, :color => '0000FF')
    end

    def guide_x(x = @pdf.cursor)
      @pdf.stroke_axis(:at => [x, 0], :height => 0, :step_length => 20, :negative_axes_length => 5, :color => '0000FF')
    end

    def initialize(order, pdf)
      @order = order
      @pdf = pdf

      header(720, order)
      body(590, order)

      @pdf.start_new_page if @pdf.cursor < 175

      footer
      pod(order)
    end

    def header(start_y, order)
      col1 = 10
      col2 = 80

      @pdf.bounding_box([0, start_y], :width => 540, :height => 120) do
        y = @pdf.cursor

        @pdf.formatted_text_box [{ text: "Invoice:", styles: [:bold] }], :at => [col1, y]
        @pdf.formatted_text_box [{ text: order.order_number.upcase }], :at => [col2, y]

        y = @pdf.cursor - 30
        @pdf.formatted_text_box [{ text: "Delivery date:", size: 10}], :at => [col1, y]
        @pdf.formatted_text_box [{ text: order.delivery_date.strftime('%m/%d/%y'), size: 10 }], :at => [col2, y]

        y = @pdf.cursor - 45
        @pdf.formatted_text_box [{ text: "Due date:", size: 10}], :at => [col1, y]
        @pdf.formatted_text_box [{ text: order.due_date.strftime('%m/%d/%y'), size: 10 }], :at => [col2, y]

        y = @pdf.cursor - 60
        @pdf.bounding_box([col1, y], :width => 50, :height => 20) do
         @pdf.formatted_text_box [{ text: "Ship to:", size: 10}], :valign => :bottom
        end

        @pdf.bounding_box([col2, y], :width => 300, :height => 20) do
         name = "#{order.location.company.name} - #{order.location.name} - #{order.location.code.upcase}"
         @pdf.formatted_text_box [{ text: name, size: 12, styles: [:bold, :italic] }], :valign => :bottom
        end

        y = @pdf.cursor - 5
        @pdf.bounding_box([col2, y], :width => 300, :height => 30) do
          @pdf.formatted_text_box [{ text: order.location.address.to_s, size: 10 }]
        end
      end

      @pdf.image "app/assets/images/logo.png", :width => 120, :at => [ 430, start_y+10]
    end

    def body(start_y, order)
      @pdf.move_cursor_to start_y
      table_header

      @pdf.move_down 5
      order.order_items
        .select{|oi| oi.has_quantity?}
        .each_with_index do |order_item, index|
          order_row(order_item, index)
        end

      shipping(order.shipping)
      total(order.total)
    end

    def table_header
      y = @pdf.cursor
      height = 12

      @pdf.bounding_box([-10, y], :width => 30, :height => height) do
       @pdf.formatted_text_box [{ text: "#", styles: [:bold], size: 9 }], :align => :right
      end

      @pdf.bounding_box([20, y], :width => 30, :height => height) do
       @pdf.formatted_text_box [{ text: "QTY", styles: [:bold], size: 9 }], :align => :right
      end

      @pdf.bounding_box([60, y], :width => 60, :height => height) do
       @pdf.formatted_text_box [{ text: "PRODUCT", styles: [:bold], size: 9 }], :align => :left
      end

      @pdf.bounding_box([450, y], :width => 35, :height => height) do
       @pdf.formatted_text_box [{ text: "PRICE", styles: [:bold], size: 9 }], :align => :right
      end

      @pdf.bounding_box([500, y], :width => 35, :height => height) do
       @pdf.formatted_text_box [{ text: "TOTAL", styles: [:bold], size: 9 }], :align => :right
      end
    end

    def order_row(order_item, index)
      y = @pdf.cursor
      height = 17

      @pdf.line_width = 0.5

      @pdf.transparent(0.5) { @pdf.stroke_horizontal_line 0, 540, :at => y + 2 }

      @pdf.bounding_box([-10, y], :width => 30, :height => height) do
       @pdf.formatted_text_box [{ text: "#{index + 1}.", size: 8, styles: [:italic]}], :align => :right, :valign => :center
      end

      @pdf.bounding_box([20, y], :width => 30, :height => height) do
       @pdf.formatted_text_box [{ text: order_item.quantity.to_i.to_s, size: 11}], :align => :right, :valign => :center
      end

      @pdf.bounding_box([60, y], :width => 100, :height => height) do
       @pdf.formatted_text_box [{ text: order_item.item.name, size: 9}], :align => :left, :valign => :center
      end

      @pdf.bounding_box([170, y], :width => 290, :height => height) do
        desc = Maybe(order_item).item.description._.truncate(61)
        @pdf.formatted_text_box [{ text: desc, size: 9}], :align => :left, :valign => :center
      end

      @pdf.bounding_box([450, y], :width => 35, :height => height) do
       @pdf.formatted_text_box [{ text: order_item.unit_price.to_s, size: 9}], :align => :right, :valign => :center
      end

      @pdf.bounding_box([500, y], :width => 35, :height => height) do
       @pdf.formatted_text_box [{ text: order_item.total.to_s, size: 9}], :align => :right, :valign => :center
      end

      @pdf.move_down 4

      @pdf.start_new_page if @pdf.cursor < 20
    end

    def shipping(val)
      y = @pdf.cursor
      @pdf.line_width = 1

      @pdf.dash(1, :space => 0, :phase => 0)
      @pdf.stroke_horizontal_line 380, 540

      @pdf.bounding_box([340, y], :width => 100, :height => 20) do
       @pdf.formatted_text_box [{ text: 'Shipping', size: 9, styles:[:bold]}], :align => :right, :valign => :center
      end

      @pdf.bounding_box([500, y], :width => 35, :height => 20) do
       @pdf.formatted_text_box [{ text: val.to_s, size: 11}], :align => :right, :valign => :center
      end
    end

    def total(val)
      y = @pdf.cursor
      @pdf.line_width = 0.25

      @pdf.dash(1, :space => 0, :phase => 0)
      @pdf.stroke_horizontal_line 380, 540

      @pdf.bounding_box([340, y], :width => 100, :height => 20) do
       @pdf.formatted_text_box [{ text: 'Total', size: 9, styles:[:bold]}], :align => :right, :valign => :center
      end

      @pdf.bounding_box([500, y], :width => 35, :height => 20) do
       @pdf.formatted_text_box [{ text: val.to_s, size: 11}], :align => :right, :valign => :center
      end
    end

    def pod(order)
      size = 30
      y = 730
      x = 440
      rotation = -90

      pod = Maybe(order).fulfillment.pod._
      signature = Maybe(pod).signature._

      if signature.present?
        img = StringIO.new(Base64.decode64(signature['data:image/png;base64,'.length .. -1]))

        @pdf.rotate(rotation, :origin => [x, y]) do

          @pdf.bounding_box([x, y], :width => size*4, :height => size) do
            @pdf.formatted_text_box [{ text: 'Received', size: size/3}], :align => :left, :valign => :bottom
          end

          y = @pdf.cursor
          @pdf.bounding_box([x, y], :width => size*4, :height => size) do
           @pdf.image img, :height => size, :position => :center, :vposition => :bottom

           @pdf.stroke_color "FF5500"
           @pdf.line_width = 1
           @pdf.join_style = :miter
           @pdf.stroke_bounds

           @pdf.stroke_color "000000"
         end

         y = @pdf.cursor - 5
         @pdf.bounding_box([x, y], :width => size*4, :height => size/3) do
           name = pod.name
           date = pod.signed_at.strftime('%d/%m/%y - %l:%m%P')
           @pdf.formatted_text_box [{ text: "#{date} - #{name}", size: size/4.5, styles: [:italic, :bold]}], :align => :left, :valign => :top
         end

       end

      end
    end

    def footer
      @pdf.svg IO.read("app/assets/images/invoice_footer.svg"), :at => [0, 140], :width => 540
    end

  end
end
