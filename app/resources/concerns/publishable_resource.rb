module PublishableResource
  extend ActiveSupport::Concern

  included do
    attributes :published_state

    filter     :published_state
  end
end
