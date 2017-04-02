include StringUtils
include ActionView::Helpers::NumberHelper

module Pdf
  module Elements
    def guide(pdf)
      pdf.stroke_axis
    end

    def guide_y(pdf)
      pdf.stroke_axis(:at => [0, pdf.cursor], :height => 0, :step_length => 20, :negative_axes_length => 5, :color => '0000FF')
    end

    def guide_x(pdf)
      pdf.stroke_axis(:at => [pdf.cursor, 0], :height => 0, :step_length => 20, :negative_axes_length => 5, :color => '0000FF')
    end

    def logo(pdf)
      pdf.image "app/assets/images/logo.png", :width => 100, :at => [ 440, 730]
    end

    def pod(pod, pdf)
      return unless pod.present?

      size = 30
      y = 730
      x = 440
      rotation = -90

      signature = Maybe(pod).signature._

      if signature.present?
        img = StringIO.new(Base64.decode64(signature['data:image/png;base64,'.length .. -1]))

        pdf.rotate(rotation, :origin => [x, y]) do

          pdf.bounding_box([x, y], :width => size*4, :height => size) do
            pdf.formatted_text_box [{ text: 'Received', size: size/3}], :align => :left, :valign => :bottom
          end

          y = pdf.cursor
          pdf.bounding_box([x, y], :width => size*4, :height => size) do
           pdf.image img, :height => size, :position => :center, :vposition => :bottom

           pdf.stroke_color "FF5500"
           pdf.line_width = 1
           pdf.join_style = :miter
           pdf.stroke_bounds

           pdf.stroke_color "000000"
         end

         y = pdf.cursor - 5
         pdf.bounding_box([x, y], :width => size*4, :height => size/3) do
           name = pod.name
           date = pod.signed_at.strftime('%a - %m/%d/%y - %I:%M%P')
           pdf.formatted_text_box [{ text: "#{date} - #{name}", size: size/4.5, styles: [:italic, :bold]}], :align => :left, :valign => :top
         end

       end

      end
    end

    def table_header(row, pdf)
      return unless row.present?

      y = pdf.cursor
      height = 12

      row.each do |col|
        pdf.bounding_box([col[:x], y], width: col[:width], height: height) do
          pdf.formatted_text_box [{ text: col[:label], styles: [:bold], size: 9 }], align: col[:align], valign: :center
        end
      end
    end

    def line_item_table(rows, pdf)
      return unless rows.present?
      table_header(rows.first, pdf)

      pdf.move_down 5

      rows
        .each do |row|
          line_item(row, pdf)
        end
    end

    def line_item(row, pdf)
      y = pdf.cursor
      height = 18

      pdf.line_width = 0.5

      pdf.transparent(0.5) { pdf.stroke_horizontal_line 0, 540, :at => y + 2 }

      row.each do |col|
        pdf.bounding_box([col[:x], y], width: col[:width], height: height) do
          pdf.formatted_text_box [col[:content]], align: col[:align], valign: :center
        end
      end

      pdf.move_down 4

      pdf.start_new_page if pdf.cursor < 20
    end

    def shipping(val, pdf)
      y = pdf.cursor
      pdf.line_width = 1

      pdf.stroke_horizontal_line 380, 540

      pdf.bounding_box([340, y], :width => 100, :height => 20) do
       pdf.formatted_text_box [{ text: 'Shipping', size: 9, styles:[:bold]}], :align => :right, :valign => :center
      end

      pdf.bounding_box([500, y], :width => 35, :height => 20) do
       pdf.formatted_text_box [{ text: number_with_precision(val, precision:2), size: 11}], :align => :right, :valign => :center
      end
    end

    def total(val, pdf)
      y = pdf.cursor
      pdf.line_width = 0.25

      pdf.dash(1, :space => 0, :phase => 0)
      pdf.stroke_horizontal_line 380, 540

      pdf.bounding_box([340, y], :width => 100, :height => 20) do
       pdf.formatted_text_box [{ text: 'Total', size: 9, styles:[:bold]}], :align => :right, :valign => :center
      end

      pdf.bounding_box([500, y], :width => 35, :height => 20) do
       pdf.formatted_text_box [{ text: number_with_precision(val, precision:2), size: 11}], :align => :right, :valign => :center
      end
    end

    def comment(comment, pdf)
      if comment.present?
        y = pdf.cursor - 10

        pdf.dash(1, :space => 5, :phase => 0)
        pdf.transparent(0.5) { pdf.stroke_horizontal_line 0, 540, :at => y}

        y = pdf.cursor - 15

        pdf.bounding_box([0, y], :width => 100, :height => 20) do
         pdf.formatted_text_box [{ text: 'Notes', size: 10, styles:[:bold]}], :valign => :top
        end

        y = pdf.cursor + 5

        pdf.bounding_box([0, y], :width => 500) do
         pdf.formatted_text_box [{ text: comment, size: 9}], :valign => :top
        end

        pdf.move_down (count_lines(comment) * 10)
      end
    end

    def footer(svg, pdf)
      y = 140

      pdf.start_new_page if pdf.cursor < y
      pdf.svg IO.read(svg), :at => [0, y], :width => 540
    end

  end
end
