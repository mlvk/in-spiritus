class TestingController < ActionController::Base
  def pdf
    GeneratePdfWorker.new.perform(Order.first)
  end
end
