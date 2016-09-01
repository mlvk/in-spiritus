#### Users
admin = User.create(first_name:'Tony', last_name:'Starks', email:'admin@wutang.com', authentication_token:'admin_token', password:'password')
admin.set_admin_role!
admin.save

FactoryGirl.create_list(:user, 2, :driver)

FactoryGirl.create_list(:item, 20, tag: Item::PRODUCT_TYPE, is_sold: true, is_purchased: false)

FactoryGirl.create_list(:price_tier, 5, items: Item.product)

FactoryGirl.create_list(:company_with_locations, 20, location_count: 4)
FactoryGirl.create_list(:company_with_locations, 5, :vendor, location_count: 5)

Company.customer.each do |company|
  company.locations.each do |location|
    notification_rule = FactoryGirl.create(
      :notification_rule,
      location: location)

    order = FactoryGirl.create(
      :order_with_items,
      :sales_order,
      items: Item.product,
      location: location)

    FactoryGirl.create(
      :notification,
      :renderer,
      order:order,
      notification_rule: notification_rule)

    Item.product.each do |item|
      FactoryGirl.create(
        :item_desire,
        location:location,
        item: item)

      FactoryGirl.create(
        :item_credit_rate,
        location:location,
        item: item)
    end
  end
end

Company.vendor.each do |company|
  items = FactoryGirl.create_list(
    :item, 10,
    tag: Item::INGREDIENT_TYPE,
    company: company,
    is_sold: false,
    is_purchased: true)

  company.locations.each do |location|
    notification_rule = FactoryGirl.create(
      :notification_rule,
      location: location)

    order = FactoryGirl.create(
      :order_with_items,
      :purchase_order,
      items: items,
      location: location)

    FactoryGirl.create(
      :notification,
      :renderer,
      order:order,
      notification_rule: notification_rule)
  end
end

3.times do
  route_visits = RouteVisit.all.sample 30

  # Set position value for route visits
  position = 0
  route_visits.each do |rv|
    rv.position = position
    position += 10
  end

  FactoryGirl.create(
    :route_plan,
    user: User.all.sample,
    route_visits: route_visits)
end
