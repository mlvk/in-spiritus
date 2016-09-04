
class TestingController < ActionController::Base
  include PdfUtils

  def pdf
    @url = generate_pdfs Order.find(1)
  end
end
