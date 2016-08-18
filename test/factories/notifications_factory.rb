FactoryGirl.define do
  factory :notification do
    notification_rule

    trait :processed do
      notification_state { Notification.notification_states[:processed] }
    end
  end
end
