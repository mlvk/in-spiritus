namespace :customers do

  desc "Create CSV on all customer fields"

  task :ng_locations => :environment do

    CSV.open("#{Rails.root}/tmp/csv/ng_locations#{Time.current.to_i}.csv", "wb") do |csv|
      Company
        .customer
        .flat_map(&:locations)
        .select{|l|
          l
            .item_desires
            .select{|item_desire| ng_codes.include? item_desire.item.id }
            .present?
        }
        .each {|l|

          csv << [
            l.company.name,
            l.name,
            l.address.street,
            l.address.city,
            l.address.zip
          ]
        }

        # csv << ["row", "of", "CSV", "data"]
    end
  end

  task :all_locations => :environment do

    ng_codes = [15, 21, 13, 22, 20, 24, 19, 23]

    CSV.open("#{Rails.root}/tmp/csv/all_locations#{Time.current.to_i}.csv", "wb") do |csv|
      Company
        .customer
        .flat_map(&:locations)
        .each {|l|

          csv << [
            l.company.name,
            l.name,
            l.address.street,
            l.address.lat,
            l.address.lng,
            l.address.city,
            l.address.zip
          ]
        }
    end
  end

end
