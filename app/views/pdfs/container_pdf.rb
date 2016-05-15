module Pdfs
  class ContainerPdf
    include Prawn::View
    # include Invoice

    def initialize(models: [])
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

      # build_invoice Order.first

      # orders.each do |order|
      #   build_invoice order
      #   start_new_page unless order == orders.last
      # end
    end

  end
end
