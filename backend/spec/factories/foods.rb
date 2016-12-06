FactoryGirl.define do
  factory :food do
    sequence(:ndb_no) { |n| "id#{n}" }

    comname   { FFaker::Lorem.sentence }
    long_desc { FFaker::Lorem.sentence }
    sciname   { FFaker::Lorem.sentence }
    shrt_desc { FFaker::Lorem.sentence }
  end
end
