class CreditNoteItemPolicy < StandardPolicy

  def create?
  	is_standard?
  end

  def update?
  	is_standard?
  end

end
