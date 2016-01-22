# == Schema Information
#
# Table name: profiles
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  country_id         :string
#  birth_date         :date
#  sex_id             :string
#  onboarding_step_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ProfileSerializer < ApplicationSerializer
  attributes :id, :birth_date, :country_id, :sex_id, :onboarding_step_id
end
