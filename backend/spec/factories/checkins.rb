FactoryGirl.define do
  factory :checkin do
    user_id { FactoryGirl.create(:user).id }
  end
end
