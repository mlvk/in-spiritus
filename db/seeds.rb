#### Users
admin = User.create(first_name:'Tony', last_name:'Starks', email:'admin@wutang.com', authentication_token:'admin_token', password:'password')
admin.set_admin_role!
admin.save

#### Items
Item.create(name:'Sunseed Chorizo', description: 'Tasty collard wrap', position: 1, is_sold:true, is_purchased:false)
Item.create(name:'Pepita Pesto Wrap', description: 'Tasty collard wrap', position: 2, is_sold:true, is_purchased:false)
Item.create(name:'Perfectly Pad Thai', description: 'Perfectly Pad Thai', position: 3, is_sold:true, is_purchased:false)
Item.create(name:'Kinky Quinoa', description: 'Quinoa Salad', position: 4, is_sold:true, is_purchased:false)
Item.create(name:'French Lentils', description: 'French lentil salad', position: 5, is_sold:true, is_purchased:false)
Item.create(name:'Almond Turmeric', description: 'Almond turmeric food bar', position: 6, is_sold:true, is_purchased:false)
Item.create(name:'Almond Cacao', description: 'Almond cacao food bar', position: 7, is_sold:true, is_purchased:false)
Item.create(name:'Hail to Kale', description: 'Kale Salad', position: 8, is_sold:true, is_purchased:false)

#### Price Tiers
distributor_price_tier = PriceTier.create(name:'Distributor')
wholesale_price_tier = PriceTier.create(name:'Wholesale')
retail_price_tier = PriceTier.create(name:'Retail')

#### Item Prices
PriceTier.all.each do |pt|
  Item.all.each do |item|
    ItemPrice.create({price_tier:pt, item:item, price:rand(1..10)})
  end
end

#### Companies

naturewell = Company.create(
  name: 'Nature Well',
  code: 'nw',
  terms: 14,
  price_tier: wholesale_price_tier)

#### Locations
# Location.create(
#   code: 'wt-001',
#   name: 'Staten',
#   active: true,
#   delivery_rate: 10,
#   company: wutang)
#
# Location.create(
#   code: 'wt-002',
#   name: 'Brooklyn',
#   active: true,
#   delivery_rate: 10,
#   company: wutang)
#
# Location.create(
#   code: 'wt-003',
#   name: 'Manhattan',
#   active: true,
#   delivery_rate: 15,
#   company: wutang)

addr1 = Address.create(
  street: '4011 Sunset Blvd',
  city: 'los angeles',
  state: 'ca',
  zip: '90026',
  lat: 34.0928448,
  lng: -118.2826394)

addr2 = Address.create(
  street: '3824 sunset blvd',
  city: 'los angeles',
  state: 'ca',
  zip: '90026',
  lat: 34.0912512,
  lng: -118.2817353)

Location.create(
  code: 'nw-001',
  name: 'Silverlake',
  active: true,
  delivery_rate: 10,
  company: naturewell,
  address: addr1)

Location.create(
  code: 'nw-002',
  name: 'Silverlake 2',
  active: true,
  delivery_rate: 10,
  company: naturewell,
  address: addr2)

Location.all.each do |location|
  Item.all.each do |item|
    ItemDesire.create(item:item, location:location, enabled:true)
  end

  (0..6).each do |day|
    VisitDay.create(day:day, location:location)
  end

  vw = VisitWindow.create(location:location, service:10, min: 480, max:720)

  (0..6).each do |day|
    VisitWindowDay.create(day:day, visit_window:vw)
  end

  NotificationRule.create(first_name:'Aram', email:'az@mlvegankitchen.com', location:location)

  yesterday = Date.today - 1
  order = Order.create(location:location, delivery_date:yesterday)
  Item.all.each do |item|
    OrderItem.create(order:order, item:item, quantity:rand(0..10), unit_price:rand(0..10))
  end

  tomorrow = Date.today + 1
  order = Order.create(location:location, delivery_date:tomorrow)
  Item.all.each do |item|
    OrderItem.create(order:order, item:item, quantity:rand(0..10), unit_price:rand(0..10))
  end
end
