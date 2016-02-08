#### Users
admin = User.create(first_name:'Tony', last_name:'Starks', email:'ts@wutang.com', authentication_token:'debug_token', password:'password')
admin.set_admin_role!
admin.save
#
#### Price Tiers
wholesale_price_tier = PriceTier.create(name:'Retail')

#### Companies
wutang = Company.create(
  name: 'Wu-Tang Corp',
  code: 'wt',
  credit_rate: 0.5,
  terms: 14,
  price_tier: wholesale_price_tier)

#### Locations
location = Location.create(
  code: 'wt-001',
  name: 'Staten',
  active: true,
  delivery_rate: 10)
#
# naughty_by_nature = Client.create(
#   code: 'nbn-001',
#   company: 'Naught By Nature',
#   nickname: 'Brooklyn',
#   active: true,
#   delivery_rate: 5,
#   credit_rate: 0.5,
#   terms: 7,
#   price_tier: wholesale_price_tier)

#### Items
ssc = Item.create(
  code: 'Sunseed Chorizo',
  description: 'Tasty collard wrap',
  position: 1)

pp = Item.create(
  code:'Pepita Pesto Wrap',
  description: 'Tasty collard wrap',
  position: 1)

kk = Item.create(
  code:'Kinky Quinoa',
  description: 'Quinoa Salad',
  position: 1)
