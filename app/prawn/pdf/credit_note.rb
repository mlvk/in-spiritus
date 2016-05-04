module Pdf
  class CreditNote
    include Prawn::View

    def guide_y(y = cursor)
      stroke_axis(:at => [0, y], :height => 0, :step_length => 20, :negative_axes_length => 5, :color => '0000FF')
    end

    def initialize(credit_notes: [])
      font_families.update(
        "Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :bold => "app/assets/fonts/OpenSans-Bold.ttf",
          :bold_italic => "app/assets/fonts/OpenSans-BoldItalic.ttf",
       }
      )

      font "Open Sans"
      # stroke_axis :step_length => 20

      credit_notes.each do |credit_note|
        build_document credit_note
        start_new_page unless credit_note == credit_notes.last
      end
    end

    def build_document(credit_note)
      header(720, credit_note)
      body(560, credit_note)
      # footer
    end

    def header(start_y, credit_note)
      col1 = 10
      col2 = 80

      bounding_box([0, start_y], :width => 540, :height => 120) do
        formatted_text_box [{ text: "Credit:", styles: [:bold] }], :at => [col1, cursor]
        formatted_text_box [{ text: credit_note.credit_note_number }], :at => [col2, cursor]

        y = cursor - 30
        formatted_text_box [{ text: "Date:", size: 10}], :at => [col1, y]
        formatted_text_box [{ text: credit_note.date.strftime('%m/%d/%y'), size: 10 }], :at => [col2, y]

        y = cursor - 60
        bounding_box([col1, y], :width => 50, :height => 20) do
         formatted_text_box [{ text: "Customer:", size: 10}], :valign => :bottom
        end

        bounding_box([col2, y], :width => 300, :height => 20) do
         name = "#{credit_note.location.company.name} - #{credit_note.location.name} - #{credit_note.location.id}"
         formatted_text_box [{ text: name, size: 12, styles: [:bold, :italic] }], :valign => :bottom
        end

        y = cursor - 5
        bounding_box([col2, y], :width => 300, :height => 30) do
          # address = "#{credit_note.location.address.street}\n#{credit_note.location.address.city}, #{credit_note.location.address.state} #{credit_note.location.address.zip}"
          formatted_text_box [{ text: credit_note.location.address.to_s, size: 10 }]
          # transparent(0.5) { stroke_bounds }
        end
      end

      image "app/assets/images/logo.png", :width => 120, :at => [ 430, start_y+10]
    end

    def body(start_y, credit_note)
      move_cursor_to start_y
      table_header

      move_down 5
      credit_note.credit_note_items
        .select{|cn| cn.has_credit?}
        .each do |credit_note_item|
          credit_note_row credit_note_item
      end

      total(credit_note.total)
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
       formatted_text_box [{ text: "CREDIT", styles: [:bold], size: 9 }], :align => :right
      end

      bounding_box([500, y], :width => 35, :height => height) do
       formatted_text_box [{ text: "TOTAL", styles: [:bold], size: 9 }], :align => :right
      end
    end

    def credit_note_row(credit_note_item)
      y = cursor
      height = 20

      self.line_width = 0.5
      # dash(8, :space => 20, :phase => 5)
      transparent(0.5) { stroke_horizontal_line 0, 540, :at => y + 2 }

      bounding_box([0, y], :width => 30, :height => height) do
       formatted_text_box [{ text: credit_note_item.quantity.to_i.to_s, size: 11}], :align => :right, :valign => :center
      end

      bounding_box([40, y], :width => 100, :height => height) do
       formatted_text_box [{ text: credit_note_item.item.name, size: 9}], :align => :left, :valign => :center
      end

      bounding_box([150, y], :width => 290, :height => height) do
       formatted_text_box [{ text: credit_note_item.item.description, size: 9}], :align => :left, :valign => :center
      end

      bounding_box([450, y], :width => 35, :height => height) do
       formatted_text_box [{ text: credit_note_item.unit_price.to_s, size: 9}], :align => :right, :valign => :center
      end

      bounding_box([500, y], :width => 35, :height => height) do
       formatted_text_box [{ text: credit_note_item.total.to_s, size: 9}], :align => :right, :valign => :center
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
       formatted_text_box [{ text: 'Total credit', size: 9, styles:[:bold]}], :align => :right, :valign => :center
      end

      bounding_box([500, y], :width => 35, :height => 20) do
       formatted_text_box [{ text: val.to_s, size: 11}], :align => :right, :valign => :center
      end

    end

    def footer
      image "app/assets/images/footer.png", :at => [0, 140], :width => 540
    end

  end
end
