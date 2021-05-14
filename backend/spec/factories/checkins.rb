FactoryBot.define do
  factory :checkin do
    user_id { FactoryBot.create(:user).id }
    sequence(:date) { |n| Time.zone.now - n.days }
    note { FFaker::Lorem.sentence }
    tag_ids { FactoryBot.create_list(:tag, 2).map(&:id) }
  end
end
