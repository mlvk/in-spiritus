class NotificationRule < ActiveRecord::Base
  validates :first_name, :email, :location, presence: true

  belongs_to :location
  has_many :notifications
end
