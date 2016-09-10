class NotificationRule < ActiveRecord::Base
  validates :first_name, :email, :location, presence: true

  belongs_to :location
  has_many :notifications, dependent: :destroy

  def full_name
    full_name = "#{first_name.titleize} #{Maybe(last_name).fetch('').titleize}"
    full_name.strip! || full_name
  end
end
