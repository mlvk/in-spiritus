class StandardPolicy

  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def is_admin?
    @current_user.admin?
  end

  def is_standard?
    @current_user.admin? or @current_user.driver? or @current_user.accountant?
  end

  def is_admin_or_driver?
    @current_user.admin? or @current_user.driver?
  end

  def index?
    is_admin?
  end

  def show?
    is_admin?
  end

  def create?
  	is_admin?
  end

  def update?
  	is_admin?
  end

  def destroy?
  	is_admin?
  end

  def get_related_resource?
    is_admin?
  end

  def get_related_resources?
    is_admin?
  end

end
