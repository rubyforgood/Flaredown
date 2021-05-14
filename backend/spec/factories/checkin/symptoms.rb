FactoryBot.define do
  factory :checkin_symptom, class: Checkin::Symptom do
    transient do
      values { [(0..4).to_a + [nil]] }
    end
    symptom_id { FactoryBot.create(:symptom).id }
    value { values.sample }
  end
end
