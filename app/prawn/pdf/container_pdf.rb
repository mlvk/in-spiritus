module Pdf
  class ContainerPdf

    def initialize(conversions: [])
      @pdf = Prawn::Document.new
      @pdf.font_families.update(
        "Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :bold => "app/assets/fonts/OpenSans-Bold.ttf",
          :bold_italic => "app/assets/fonts/OpenSans-BoldItalic.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf"
       }
      )

      @pdf.font "Open Sans"
      # stroke_axis :step_length => 20

      conversions.each do |conversion|
        conversion[:renderer].new(conversion[:data], @pdf)
        @pdf.start_new_page unless conversion == conversions.last
      end
    end

    def render
      @pdf.render
    end

    def render_file(url)
      @pdf.render_file url
    end
  end
end
