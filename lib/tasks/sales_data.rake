require "#{Rails.root}/app/utils/firebase_utils"

namespace :sales_data do
  include FirebaseUtils
  desc "Sales Forecasting Tools"

  task :rebuild_firebase => :environment do
    StockLevel
      .fulfillment_fulfilled
      .each do |sl|
        build_stock_level_data_point sl
      end
  end
end
