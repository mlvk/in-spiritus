class CompanyPolicy < StandardPolicy
  def index?
    @current_user.admin? or @current_user.driver? or @current_user.accountant?
  end

  def show?
    @current_user.admin? or @current_user.driver? or @current_user.accountant?
  end
end
