module Pdf
  class Invoice
    include Prawn::View

    def guide_y(y = cursor)
      stroke_axis(:at => [0, y], :height => 0, :step_length => 20, :negative_axes_length => 5, :color => '0000FF')
    end

    def initialize(orders: [])
      font_families.update(
        "Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :bold => "app/assets/fonts/OpenSans-Bold.ttf",
          :bold_italic => "app/assets/fonts/OpenSans-BoldItalic.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf"
       }
      )

      font "Open Sans"
      # stroke_axis :step_length => 20

      orders.each do |order|
        build_invoice order
        start_new_page unless order == orders.last
      end
    end

    def build_invoice(order)
      header(720, order)
      body(560, order)
      pod(order)
      footer
    end

    def header(start_y, order)
      col1 = 10
      col2 = 80

      bounding_box([0, start_y], :width => 540, :height => 120) do
        formatted_text_box [{ text: "Invoice:", styles: [:bold] }], :at => [col1, cursor]
        formatted_text_box [{ text: order.order_number }], :at => [col2, cursor]

        y = cursor - 30
        formatted_text_box [{ text: "Delivery date:", size: 10}], :at => [col1, y]
        formatted_text_box [{ text: order.delivery_date.strftime('%m/%d/%y'), size: 10 }], :at => [col2, y]

        y = cursor - 45
        formatted_text_box [{ text: "Due date:", size: 10}], :at => [col1, y]
        formatted_text_box [{ text: order.due_date.strftime('%m/%d/%y'), size: 10 }], :at => [col2, y]

        y = cursor - 60
        bounding_box([col1, y], :width => 50, :height => 20) do
         formatted_text_box [{ text: "Ship to:", size: 10}], :valign => :bottom
        end

        bounding_box([col2, y], :width => 300, :height => 20) do
         name = "#{order.location.company.name} - #{order.location.name} - #{order.location.id}"
         formatted_text_box [{ text: name, size: 12, styles: [:bold, :italic] }], :valign => :bottom
        end

        y = cursor - 5
        bounding_box([col2, y], :width => 300, :height => 30) do
          # address = "#{order.location.address.street}\n#{order.location.address.city}, #{order.location.address.state} #{order.location.address.zip}"
          formatted_text_box [{ text: order.location.address.to_s, size: 10 }]
          # transparent(0.5) { stroke_bounds }
        end
      end

      image "app/assets/images/logo.png", :width => 120, :at => [ 430, start_y+10]
    end

    def body(start_y, order)
      move_cursor_to start_y
      table_header

      move_down 5
      order.order_items
        .select{|oi| oi.has_quantity?}
        .each do |order_item|
          order_row order_item
      end

      total(order.total)
    end

    def table_header
      y = cursor
      height = 12

      bounding_box([0, y], :width => 30, :height => height) do
       formatted_text_box [{ text: "QTY", styles: [:bold], size: 9 }], :align => :right
      end

      bounding_box([40, y], :width => 60, :height => height) do
       formatted_text_box [{ text: "PRODUCT", styles: [:bold], size: 9 }], :align => :left
      end

      bounding_box([450, y], :width => 35, :height => height) do
       formatted_text_box [{ text: "PRICE", styles: [:bold], size: 9 }], :align => :right
      end

      bounding_box([500, y], :width => 35, :height => height) do
       formatted_text_box [{ text: "TOTAL", styles: [:bold], size: 9 }], :align => :right
      end
    end

    def order_row(order_item)
      y = cursor
      height = 20

      self.line_width = 0.5
      # dash(8, :space => 20, :phase => 5)
      transparent(0.5) { stroke_horizontal_line 0, 540, :at => y + 2 }

      bounding_box([0, y], :width => 30, :height => height) do
       formatted_text_box [{ text: order_item.quantity.to_i.to_s, size: 11}], :align => :right, :valign => :center
      end

      bounding_box([40, y], :width => 100, :height => height) do
       formatted_text_box [{ text: order_item.item.name, size: 9}], :align => :left, :valign => :center
      end

      bounding_box([150, y], :width => 290, :height => height) do
       formatted_text_box [{ text: order_item.item.description, size: 9}], :align => :left, :valign => :center
      end

      bounding_box([450, y], :width => 35, :height => height) do
       formatted_text_box [{ text: order_item.unit_price.to_s, size: 9}], :align => :right, :valign => :center
      end

      bounding_box([500, y], :width => 35, :height => height) do
       formatted_text_box [{ text: order_item.total.to_s, size: 9}], :align => :right, :valign => :center
      end

      move_down 4
    end

    def total(val)
      # guide_y
      y = cursor
      self.line_width = 1

      dash(1, :space => 0, :phase => 0)
      stroke_horizontal_line 380, 540

      bounding_box([340, y], :width => 100, :height => 20) do
       formatted_text_box [{ text: 'Total', size: 9, styles:[:bold]}], :align => :right, :valign => :center
      end

      bounding_box([500, y], :width => 35, :height => 20) do
       formatted_text_box [{ text: val.to_s, size: 11}], :align => :right, :valign => :center
      end

    end

    def pod(order)
      y = cursor - 20
      x = 170
      signature = Maybe(order).fulfillment.pod.signature._

      if signature.present?
        img = StringIO.new(Base64.decode64(signature['data:image/png;base64,'.length .. -1]))

        bounding_box([x, y], :width => 200, :height => 50) do
          formatted_text_box [{ text: 'Received', size: 23}], :align => :left, :valign => :bottom
        end

        y = cursor
        bounding_box([x, y], :width => 200, :height => 50) do
         image img, :height => 50, :position => :center, :vposition => :bottom

         stroke_color "FF5500"
         self.line_width = 2
         self.join_style = :miter
         stroke_bounds
       end

       y = cursor - 5
       bounding_box([x, y], :width => 200, :height => 15) do
         formatted_text_box [{ text: '01/12/16 - 10:42am', size: 11, styles: [:italic, :bold]}], :align => :left, :valign => :top
       end

       y = cursor
       bounding_box([x, y], :width => 200, :height => 15) do
         formatted_text_box [{ text: 'Received by Aram Zadikian', size: 11, styles: [:italic]}], :align => :left, :valign => :top
       end

       image "app/assets/images/stamp_icon.png", :at => [x + 175, y+50], :width => 50
      end
    end

    def footer
      image "app/assets/images/footer.png", :at => [0, 140], :width => 540
    end

  end
end
