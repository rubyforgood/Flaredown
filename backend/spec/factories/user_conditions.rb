# == Schema Information
#
# Table name: user_conditions
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  condition_id :integer
#  user_id      :integer
#
# Indexes
#
#  index_user_conditions_on_condition_id  (condition_id)
#  index_user_conditions_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (condition_id => conditions.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :user_condition do
    user
    association :condition, :personal
  end
end
