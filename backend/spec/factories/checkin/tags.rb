FactoryGirl.define do
  factory :checkin_tag, class: Checkin::Tag do
    name { FFaker::Lorem.word }
  end
end
