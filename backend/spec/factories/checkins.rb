FactoryGirl.define do
  factory :checkin do
    user_id { FactoryGirl.create(:user).id }
    sequence(:date) { |n| Time.now-n.days }
    note { FFaker::Lorem.sentence }

    transient do
      tags_count 3
    end

    after(:create) do |checkin, evaluator|
      checkin.tags = create_list(:checkin_tag, evaluator.tags_count)
    end
  end
end
