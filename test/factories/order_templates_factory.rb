FactoryGirl.define do
  factory :order_template do
    start_date { Date.today }
    frequency 1
    location

    factory :order_template_with_items do
      transient do
        items nil
        order_template_items_count 5
      end

      after(:create) do |order_template, evaluator|
        if evaluator.items.present?
          evaluator.items.each do |item|
            create(:order_template_item, order_template: order_template, item:item)
          end
        else
          create_list(:order_template_item, evaluator.order_template_items_count, order_template: order_template)
        end
      end
    end
  end
end
