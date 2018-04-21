class CreditNotePolicy < DriverPolicy

  def create?
  	is_standard?
  end
  
end
