# == Schema Information
#
# Table name: profiles
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  country_id         :string
#  birth_date         :date
#  sex_id             :string
#  onboarding_step_id :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :profile do
    birth_date (25..55).to_a.sample.years.ago
    country_id FFaker::Address.country_code
    sex_id Sex.all_ids.sample
  end
end
