# == Schema Information
#
# Table name: weathers
#
#  id               :integer          not null, primary key
#  date             :date
#  humidity         :float
#  icon             :string
#  postal_code      :string
#  precip_intensity :float
#  pressure         :float
#  summary          :string
#  temperature_max  :float
#  temperature_min  :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  position_id      :integer
#
# Indexes
#
#  index_weathers_on_date_and_postal_code  (date,postal_code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (position_id => positions.id)
#
FactoryBot.define do
  factory :weather do
    date { "MyString" }
    postal_code { "MyString" }
    icon { "MyString" }
    temperature_min { 1.5 }
    temperature_max { 1.5 }
    precip_intensity { 1.5 }
    pressure { 1.5 }
    humidity { 1.5 }
  end
end
