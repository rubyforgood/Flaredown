FactoryBot.define do
  factory :harvey_bradshaw_index do
    checkin_id { FactoryBot.create(:checkin).id }

    stools { 3 }
    well_being { 1 }
    abdominal_mass { 0 }
    abdominal_pain { 2 }
  end
end
