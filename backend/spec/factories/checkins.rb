FactoryGirl.define do
  factory :checkin do
    user_id { FactoryGirl.create(:user).id }
    sequence(:date) { |n| Time.zone.now - n.days }
    note { FFaker::Lorem.sentence }
    tag_ids { FactoryGirl.create_list(:tag, 2).map(&:id) }
  end
end
