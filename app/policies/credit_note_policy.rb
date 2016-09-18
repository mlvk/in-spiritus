class CreditNotePolicy < StandardPolicy

  def create?
  	is_standard?
  end

  def update?
  	is_standard?
  end
  
end
