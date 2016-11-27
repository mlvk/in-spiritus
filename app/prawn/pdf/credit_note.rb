module Pdf
  class CreditNote
    include Pdf::Elements

    def initialize(credit_note, pdf)
      logo(pdf)

      pod(Maybe(credit_note).fulfillment.pod._, pdf)

      header(credit_note, pdf)

      line_item_table(build_line_items(credit_note), pdf)

      total(credit_note.total, pdf)

      pdf.start_new_page if pdf.cursor < 175

      footer("app/assets/images/credit_note_footer.svg", pdf)
    end

    def header(credit_note, pdf)
      start_y = 720
      col1 = 10
      col2 = 110

      pdf.bounding_box([0, start_y], :width => 540, :height => 120) do
        y = pdf.cursor

        pdf.formatted_text_box [{ text: "Credit Note:", styles: [:bold] }], :at => [col1, y]
        pdf.formatted_text_box [{ text: credit_note.credit_note_number.upcase }], :at => [col2, y]

        y = pdf.cursor - 30
        pdf.formatted_text_box [{ text: "Date:", size: 10}], :at => [col1, y]
        pdf.formatted_text_box [{ text: credit_note.date.strftime('%m/%d/%y'), size: 10 }], :at => [col2, y]

        y = pdf.cursor - 45
        pdf.bounding_box([col1, y], :width => 50, :height => 20) do
         pdf.formatted_text_box [{ text: "Credit for:", size: 10}], :valign => :bottom
        end

        pdf.bounding_box([col2, y], :width => 300, :height => 20) do
         name = "#{credit_note.location.code.upcase} - #{credit_note.location.name} - #{credit_note.location.company.name}"
         pdf.formatted_text_box [{ text: name, size: 12, styles: [:bold, :italic] }], :valign => :bottom
        end

        y = pdf.cursor - 5
        pdf.bounding_box([col2, y], :width => 300, :height => 30) do
          pdf.formatted_text_box [{ text: credit_note.location.address.to_s, size: 10 }]
        end
      end

    end

    def build_line_items(credit_note)
      credit_note
        .credit_note_items
        .select {|cni| cni.has_quantity? }
        .each_with_index
        .map {|cni, index|
          [
            {x:5,     label:"#",      width:30,  align: :left, content:{ text: "#{index + 1}.", size: 8, styles: [:italic]}},
            {x:10,    label:"QTY",    width:30,  align: :right, content:{ text: cni.quantity.to_i.to_s, size: 11}},
            {x:60,    label:"CODE",   width:50,  align: :left,  content:{ text: cni.item.code, size: 11, styles: [:italic]}},
            {x:120,   label:"NAME",   width:120, align: :left,  content:{ text: cni.item.name, size: 9}},
            {x:260,   label:"DESC",   width:200, align: :left,  content:{ text: Maybe(cni.item.description).fetch("").truncate(121), size: 7}},
            {x:450,   label:"PRICE",  width:35,  align: :right, content:{ text: cni.unit_price.to_s, size: 9}},
            {x:500,   label:"TOTAL",  width:35,  align: :right, content:{ text: cni.total.to_s, size: 9}}
          ]
        }
    end
  end
end
