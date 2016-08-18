class NotificationRuleResource < JSONAPI::Resource
  attributes :first_name,
             :last_name,
             :email,
             :enabled,
             :wants_invoice,
             :wants_credit

  has_one  :location
  has_many :notifications

  filter :enabled
end
