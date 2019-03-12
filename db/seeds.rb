# A scale to use to build various records
companies = 2
locations = 2
users = 3
products = 10
ingredients = 2

#### Users
admin = User.create(first_name:'Tony', last_name:'Starks', email:'admin@wutang.com', authentication_token:'admin_token', password:'password')
admin.set_admin_role!
admin.save

FactoryBot.create_list(:user, users, :driver)

FactoryBot.create_list(:item, products, tag: Item::PRODUCT_TYPE, is_sold: true, is_purchased: false)

FactoryBot.create_list(:price_tier, 2, items: Item.product)

FactoryBot.create_list(:company_with_locations, companies, location_count: locations)
FactoryBot.create_list(:company_with_locations, companies, :vendor, location_count: locations)

# Company.customer.each do |company|
#   company.locations.each do |location|
#     notification_rule = FactoryBot.create(
#       :notification_rule,
#       location: location)
#
#     order = FactoryBot.create(
#       :order_with_items,
#       :sales_order,
#       items: Item.product,
#       location: location)
#
#     FactoryBot.create(
#       :notification_invalid,
#       order:order,
#       notification_rule: notification_rule)
#
#     Item.product.each do |item|
#       FactoryBot.create(
#         :item_desire,
#         location:location,
#         item: item)
#
#       FactoryBot.create(
#         :item_credit_rate,
#         location:location,
#         item: item)
#     end
#
#     FactoryBot.create(
#       :visit_day,
#       location:location,
#       day:rand(0..6))
#   end
# end

# Company.vendor.each do |company|
#   items = FactoryBot.create_list(
#     :item, ingredients,
#     tag: Item::INGREDIENT_TYPE,
#     company: company,
#     is_sold: false,
#     is_purchased: true)
#
#   company.locations.each do |location|
#     notification_rule = FactoryBot.create(
#       :notification_rule,
#       location: location)
#
#     order = FactoryBot.create(
#       :order_with_items,
#       :purchase_order,
#       items: items,
#       location: location)
#
#     FactoryBot.create(
#       :notification_invalid,
#       order:order,
#       notification_rule: notification_rule)
#   end
# end

# 3.times do
#   route_visits = RouteVisit.all.sample 30
#
#   # Set position value for route visits
#   position = 0
#   route_visits.each do |rv|
#     rv.position = position
#     position += 10
#   end
#
#   FactoryBot.create(
#     :route_plan,
#     user: User.all.sample,
#     route_visits: route_visits)
# end
