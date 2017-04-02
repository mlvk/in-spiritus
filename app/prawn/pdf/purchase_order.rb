module Pdf
  class PurchaseOrder
    include Pdf::Elements
    include ActionView::Helpers::NumberHelper

    def initialize(order, pdf)
      logo(pdf)

      pod(Maybe(order).fulfillment.pod._, pdf)

      header(order, pdf)

      line_item_table(build_line_items(order), pdf)

      shipping(order.shipping, pdf)
      total(order.total, pdf)

      comment(order.comment, pdf)

      footer("app/assets/images/purchase_order_footer.svg", pdf)
    end

    def header(order, pdf)
      start_y = 720
      col1 = 0
      col2 = 110

      pdf.bounding_box([0, start_y], :width => 540, :height => 120) do
        y = pdf.cursor

        pdf.formatted_text_box [{ text: "Purchase Order:", styles: [:bold] }], :at => [col1, y]
        pdf.formatted_text_box [{ text: order.order_number.upcase }], :at => [col2, y]

        y = pdf.cursor - 20
        pdf.formatted_text_box [{ text: "Pickup date:", size: 10}], :at => [col1, y]
        pdf.formatted_text_box [{ text: order.delivery_date.strftime('%m/%d/%y'), size: 10 }], :at => [col2, y]

        y = pdf.cursor - 30
        pdf.bounding_box([col1, y], :width => 60, :height => 20) do
         pdf.formatted_text_box [{ text: "Pickup from:", size: 10}], :valign => :bottom
        end

        pdf.bounding_box([col2, y], :width => 300, :height => 20) do
         name = "#{order.location.company.name} - #{order.location.name} - #{order.location.code.upcase}"
         pdf.formatted_text_box [{ text: name, size: 12, styles: [:bold, :italic] }], :valign => :bottom
        end

        y = pdf.cursor - 5
        pdf.bounding_box([col2, y], :width => 300, :height => 30) do
          pdf.formatted_text_box [{ text: order.location.address.to_s, size: 10 }]
        end
      end

    end

    def build_line_items(order)
      order
        .order_items
        .select(&:has_quantity?)
        .each_with_index
        .map {|oi, index|
          [
            {x:5,     label:"#",      width:30,  align: :left,  content:{ text: "#{index + 1}.", size: 8, styles: [:italic]}},
            {x:10,    label:"QTY",    width:30,  align: :right, content:{ text: oi.quantity.to_i.to_s, size: 11}},
            {x:60,    label:"CODE",   width:75,  align: :left,  content:{ text: oi.item.code, size: 9, styles: [:italic]}},
            {x:140,   label:"NAME",   width:120, align: :left,  content:{ text: oi.item.name, size: 9}},
            {x:270,   label:"DESC",   width:100, align: :left,  content:{ text: Maybe(oi.item.description).fetch("").truncate(121), size: 7}},
            {x:390,   label:"PKG",    width:40,  align: :left,  content:{ text: oi.item.unit_of_measure, size: 9}},
            {x:450,   label:"PRICE",  width:35,  align: :right, content:{ text: number_with_precision(oi.unit_price, precision:2), size: 9}},
            {x:500,   label:"TOTAL",  width:35,  align: :right, content:{ text: number_with_precision(oi.total, precision:2), size: 9}}
          ]
        }
    end
  end
end
