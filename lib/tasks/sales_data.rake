require "#{Rails.root}/app/utils/firebase_utils"

namespace :sales_data do
  include FirebaseUtils
  desc "Sales Forecasting Tools"

  task :rebuild_firebase => :environment do

    # Clear all locations
    push_payload("locations", {})

    StockLevel
      .fulfillment_fulfilled
      .select {|sl| sl.stock.fulfillment.route_visit.present? }
      .each do |sl|
        build_stock_level_data_point sl
      end
  end
end
