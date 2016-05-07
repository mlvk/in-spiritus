#### Users
admin = User.create(first_name:'Tony', last_name:'Starks', email:'admin@wutang.com', authentication_token:'admin_token', password:'password')
admin.set_admin_role!
admin.save

Location.all.each do |location|
  Item.all.each do |item|
    ItemDesire.create(item:item, location:location, enabled:true)
  end

  (0..6).each do |day|
    VisitDay.create(day:day, location:location, enabled:true)
  end

  NotificationRule.create(first_name:'Aram', email:'az@mlvegankitchen.com', location:location)
end

VisitWindow.all.each do |vw|
  (0..6).each do |day|
    VisitWindowDay.create(day:day, visit_window:vw)
  end
end
