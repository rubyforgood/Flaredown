FactoryBot.define do
  factory :checkin_condition, class: Checkin::Condition do
    transient do
      values { [(0..4).to_a + [nil]] }
    end
    condition_id { FactoryBot.create(:condition).id }
    value { values.sample }
  end
end
