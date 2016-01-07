# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  authentication_token   :string           default(""), not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  username               :string           not null
#  bio                    :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryGirl.define do
  factory :user do
    first_name  { FFaker::Name.first_name }
    last_name   { FFaker::Name.last_name }
    sequence(:username) { |number| "#{FFaker::Internet.user_name.slice(0, 10)}#{number}" }
    sequence(:email) { |number| "user#{number}@example.com" }

    password 'password123'
    password_confirmation { 'password123' }
  end
end
