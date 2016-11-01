
class TestingController < ActionController::Base
  include PdfUtils

  def pdf
    @url = generate_pdfs RoutePlan.find(43)
  end
end
