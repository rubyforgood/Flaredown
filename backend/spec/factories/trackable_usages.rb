# == Schema Information
#
# Table name: trackable_usages
#
#  id             :integer          not null, primary key
#  count          :integer          default(1)
#  trackable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trackable_id   :integer
#  user_id        :integer
#
# Indexes
#
#  index_trackable_usages_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_trackable_usages_on_unique_columns                   (user_id,trackable_type,trackable_id) UNIQUE
#  index_trackable_usages_on_user_id                          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :trackable_usage do
    user
    association :trackable, factory: :condition
  end
end
