class CreditNoteItemPolicy < DriverPolicy

  def create?
  	is_standard?
  end

  def update?
  	is_standard?
  end

end
