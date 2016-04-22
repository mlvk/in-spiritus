class FulfillmentResource < JSONAPI::Resource
  before_create :create_linked_resources

  attributes :fulfillment_state, :submitted_at

  has_one :route_visit
  has_one :stock
  has_one :order
  has_one :credit_note
  has_one :pod

  private
    def create_linked_resources
      # TODO: Think about pre building, pods, stocks, and creditNotes
      # It will simplify the client building and saving logic
    end
end
