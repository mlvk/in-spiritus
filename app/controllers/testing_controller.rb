
class TestingController < ActionController::Base
  include PdfUtils

  def pdf
    @url = generate_pdfs RoutePlan.find(45)
  end
end
