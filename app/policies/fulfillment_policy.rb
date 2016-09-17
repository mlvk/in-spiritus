class FulfillmentPolicy < StandardPolicy

  def update?
  	is_admin_or_driver?
  end
  
end
