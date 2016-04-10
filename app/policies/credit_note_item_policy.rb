class CreditNoteItemPolicy < StandardPolicy
  def create?
  	@current_user.admin? or @current_user.driver? or @current_user.accountant?
  end
end
