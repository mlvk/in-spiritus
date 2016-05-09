class TestingController < ActionController::Base
  include PdfUtils

  def pdf
    # @url = generate_and_upload_credit_notes_pdf [CreditNote.first]
    @url = generate_and_upload_orders_pdf [Order.find(63)]
  end
end
