# == Schema Information
#
# Table name: trackable_usages
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  trackable_id   :integer
#  trackable_type :string
#  count          :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  factory :trackable_usage do
    user
    association :trackable, factory: :condition
  end
end
