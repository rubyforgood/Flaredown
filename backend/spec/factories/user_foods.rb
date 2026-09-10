# == Schema Information
#
# Table name: user_foods
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  food_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_user_foods_on_food_id  (food_id)
#  index_user_foods_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (food_id => foods.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :user_food do
    user
    association :food, :personal
  end
end
