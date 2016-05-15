FactoryGirl.define do
  factory :credit_note do
    date { Date.tomorrow }
    location

    trait :pending do
      xero_state { CreditNote.xero_states[:pending] }
    end

    trait :submitted do
      xero_state { CreditNote.xero_states[:submitted] }
    end

    trait :synced do
      xero_state { CreditNote.xero_states[:synced] }
      xero_id { SecureRandom.hex(10) }
    end

    factory :credit_note_with_credit_note_items do
      transient do
        credit_note_items_count 5
        quantity 5
        unit_price 5
      end

      after(:create) do |credit_note, evaluator|
        create_list(:credit_note_item,
          evaluator.credit_note_items_count,
          quantity: evaluator.quantity,
          unit_price: evaluator.unit_price,
          credit_note: credit_note)
      end
    end

  end
end
