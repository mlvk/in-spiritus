class TestingController < ActionController::Base
  include PdfUtils

  def pdf
    @url = generate_local_pdfs [{renderer:Pdf::RoutePlan, data:RoutePlan.find(7)}]
  end
end
