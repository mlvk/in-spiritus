class OrderPolicy

  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def ping?
    @current_user.admin?
  end

  def register_device_apn?
    @current_user.admin?
  end

  def stub_orders?
    @current_user.admin?
  end

  def index?
  	@current_user.admin?
  end

  def show?
  	@current_user.admin?
  end

  def create?
  	@current_user.admin?
  end

  def update?
  	@current_user.admin?
  end

  def destroy?
  	@current_user.admin?
  end

  def get_related_resource?
    @current_user.admin?
  end

  def get_related_resources?
    @current_user.admin?
  end

end
