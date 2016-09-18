class ItemPolicy < StandardPolicy

  def get_related_resource?
    is_admin_or_driver?
  end

end
