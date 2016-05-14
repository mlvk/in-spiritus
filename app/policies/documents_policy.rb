class DocumentsPolicy < StandardPolicy
  def generate_packing_documents?
    @current_user.admin?
  end
end
