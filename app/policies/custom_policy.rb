class CustomPolicy < StandardPolicy
  def unique_check?
    is_admin?
  end
end
