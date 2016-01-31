FactoryGirl.define do
  factory :checkin_symptom, class: Checkin::Symptom do
    transient do
      values (0..4).to_a
    end
    symptom_id { FactoryGirl.create(:symptom).id }
    value { values.sample }
  end
end
