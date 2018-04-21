module Pdf
  class PackingSlip
    include Pdf::Elements
    include ActionView::Helpers::NumberHelper

    def initialize(packing_slip, pdf)
      header(packing_slip.order, pdf)

      line_item_table(build_line_items(packing_slip.order), pdf)

      comment(packing_slip.order.comment, pdf)
    end

    def header(order, pdf)
      start_y = 720
      col1 = 0
      col2 = 120

      pdf.bounding_box([0, start_y], :width => 540, :height => 120) do
        top = pdf.cursor
        y = pdf.cursor

        pdf.formatted_text_box [{ text: order.order_number.upcase, size: 20 }], align: :right, width: 200, :at => [330, y]

        y = pdf.cursor - 20
        pdf.formatted_text_box [{ text: order.delivery_date.strftime('%m/%d/%y'), size: 16 }], align: :right, width: 200, :at => [330, y]

        pdf.bounding_box([col1, top], :width => 300, :height => 26) do
         name = "#{order.location.code.upcase}"
         pdf.formatted_text_box [{ text: name, size: 24, styles: [:bold, :italic] }], :valign => :bottom
        end

        y = pdf.cursor - 5

        pdf.bounding_box([col1, y], :width => 300, :height => 20) do
         name = "#{order.location.company.name} - #{order.location.name}"
         pdf.formatted_text_box [{ text: name, size: 14, styles: [:bold, :italic] }], :valign => :bottom
        end

        y = pdf.cursor - 5

        pdf.bounding_box([col1, y], :width => 400, :height => 60) do
          pdf.formatted_text_box [{ text: order.location.address.to_s, size: 16 }]
        end
      end

      pdf.move_cursor_to start_y - 130
    end

    def build_line_items(order)
      order
        .order_items
        .select(&:has_quantity?)
        .each_with_index
        .map {|oi, index|
          [
            {x:5,     label:"#",      width:30,   height:30, align: :left,  content:{ text: "#{index + 1}.", size: 10, styles: [:italic]}},
            {x:10,    label:"QTY",    width:50,   height:30, align: :right, content:{ text: oi.quantity.to_i.to_s, size: 17, styles: [:bold]}},
            {x:90,    label:"CODE",   width:120,  height:30, align: :left,  content:{ text: oi.item.code.upcase, size: 14, styles: [:italic]}},
            {x:170,   label:"NAME",   width:150,  height:30, align: :left,  content:{ text: oi.item.name, size: 16, styles: [:bold]}},
          ]
        }
    end
  end
end
