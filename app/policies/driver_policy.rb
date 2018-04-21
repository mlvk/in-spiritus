class DriverPolicy < StandardPolicy

  def index?
    is_standard?
  end

  def show?
    is_standard?
  end

  def get_related_resource?
    is_standard?
  end

  def get_related_resources?
    is_standard?
  end

end
