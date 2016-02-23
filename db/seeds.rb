#### Users
admin = User.create(first_name:'Tony', last_name:'Starks', email:'admin@wutang.com', authentication_token:'admin_token', password:'password')
admin.set_admin_role!
admin.save
#
#### Price Tiers
distributor_price_tier = PriceTier.create(name:'Distributor')
wholesale_price_tier = PriceTier.create(name:'Wholesale')
retail_price_tier = PriceTier.create(name:'Retail')

#### Items
Item.create(name:'Sunseed Chorizo', description: 'Tasty collard wrap', position: 1)
Item.create(name:'Pepita Pesto Wrap', description: 'Tasty collard wrap', position: 2)
Item.create(name:'Perfectly Pad Thai', description: 'Quinoa Salad', position: 3)
Item.create(name:'Kinky Quinoa', description: 'Quinoa Salad', position: 4)
Item.create(name:'French Lentils', description: 'French lentil salad', position: 5)
Item.create(name:'Almond Turmeric', description: 'Almond turmeric food bar', position: 6)
Item.create(name:'Almond Cacao', description: 'Almond cacao food bar', position: 7)
Item.create(name:'Hail to Kale', description: 'Kale Salad', position: 8)

#### Companies
wutang = Company.create(
  name: 'Wu-Tang Corp',
  code: 'wt',
  credit_rate: 0.5,
  terms: 14,
  price_tier: wholesale_price_tier)

#### Locations
Location.create(
  code: 'wt-001',
  name: 'Staten',
  active: true,
  delivery_rate: 10,
  company: wutang)

Location.create(
  code: 'wt-002',
  name: 'Brooklyn',
  active: true,
  delivery_rate: 10,
  company: wutang)

Location.create(
  code: 'wt-003',
  name: 'Manhattan',
  active: true,
  delivery_rate: 15,
  company: wutang)

Location.all.each do |location|
  Item.all.each do |item|
    ItemDesire.create(item:item, location:location, enabled:true)
  end
end

tomorrow = Date.today + 1
Location.all.each do |location|
  order = Order.create(location:location, delivery_date:tomorrow)
  Item.all.each do |item|
    OrderItem.create(order:order, item:item)
  end
end
