namespace :restore do
  desc "Restore PG"

  csv_dir = File.join(Rails.root, "lib", "assets", "csv")

  task :all => [
    'db:drop',
    'db:create',
    'db:schema:load',
    :pt,
    :companies,
    :items,
    :ip,
    :addresses,
    :locations,
    :visit_windows,
    "db:seed"
  ]

  task :items => :environment do
    fields = "id,default_price,company_id,code,name,description,position,is_purchased,is_sold,tag"
    csv = "'#{csv_dir}/items.csv'"
    sql = "COPY items(#{fields}) FROM #{csv} WITH csv HEADER"
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  task :pt => :environment do
    fields = "id,name"
    csv = "'#{csv_dir}/price_tiers.csv'"
    sql = "COPY price_tiers(#{fields}) FROM #{csv} WITH csv HEADER"
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.reset_pk_sequence!('pt')
  end

  task :ip => :environment do
    fields = "id,item_id,price_tier_id,price"
    csv = "'#{csv_dir}/item_prices.csv'"
    sql = "COPY item_prices(#{fields}) FROM #{csv} WITH csv HEADER"
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.reset_pk_sequence!('ip')
  end

  task :companies => :environment do
    fields = "id,name,terms,price_tier_id,is_customer,is_vendor"
    csv = "'#{csv_dir}/companies.csv'"
    sql = "COPY companies(#{fields}) FROM #{csv} WITH csv HEADER"
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.reset_pk_sequence!('companies')
  end

  task :addresses => :environment do
    fields = "id,street,city,state,zip,lat,lng"
    csv = "'#{csv_dir}/addresses.csv'"
    sql = "COPY addresses(#{fields}) FROM #{csv} WITH csv HEADER"
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.reset_pk_sequence!('addresses')
  end

  task :locations => :environment do
    fields = "id,company_id,address_id,name,delivery_rate,active"
    csv = "'#{csv_dir}/locations.csv'"
    sql = "COPY locations(#{fields}) FROM #{csv} WITH csv HEADER"
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.reset_pk_sequence!('locations')
  end

  task :visit_windows => :environment do
    fields = "id,address_id,min,max,service"
    csv = "'#{csv_dir}/visit_windows.csv'"
    sql = "COPY visit_windows(#{fields}) FROM #{csv} WITH csv HEADER"
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.reset_pk_sequence!('visit_windows')
  end

end
