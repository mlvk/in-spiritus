
class TestingController < ActionController::Base
  include PdfUtils

  def pdf
    order = Order.find(16120)
    @url = generate_pdfs [order.packing_slip]
  end
end
