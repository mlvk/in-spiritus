module PublishableModel
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm :published_state, :column => :published_state, :skip_validation_on_save => true do
      state :unpublished, :initial => true
      state :published

      event :mark_unpublished do
        transitions :from => [:unpublished, :published], :to => :unpublished
      end

      event :mark_published do
        transitions :from => [:unpublished, :published], :to => :published
      end
    end

    enum published_state: [ :unpublished, :published ]
  end
end
