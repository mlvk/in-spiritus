namespace :route_visits do
  desc "RouteVisit utils"

  task :re_build_stock_timestamp => :environment do
    RouteVisit
      .processed
      .each { |rv|
        rv
          .fulfillments
          .flat_map(&:stock)
          .select(&:present?)
          .each {|s|
            s.update_columns(taken_at: rv.completed_at)
          }
      }
  end
end
