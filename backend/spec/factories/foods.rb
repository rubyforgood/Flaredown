# == Schema Information
#
# Table name: foods
#
#  id                     :integer          not null, primary key
#  comname                :string
#  global                 :boolean          default(TRUE)
#  long_desc              :string           not null
#  ndb_no                 :string
#  sciname                :string
#  shrt_desc              :string
#  trackable_usages_count :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_foods_on_ndb_no  (ndb_no)
#
FactoryBot.define do
  factory :food do
    sequence(:ndb_no) { |n| "id#{n}" }

    comname { FFaker::Lorem.sentence }
    long_desc { FFaker::Lorem.sentence }
    sciname { FFaker::Lorem.sentence }
    shrt_desc { FFaker::Lorem.sentence }

    trait :personal do
      global { false }
    end
  end
end
