FactoryGirl.define do
  factory :checkin_treatment, class: Checkin::Treatment do
    transient do
      values ['20 mg', '2 ml', '3 x 1 cap', '2 x 10 mg', nil, '3 x 4 ml', '1 cap', '5 ml', '2 x 2 cap']
    end
    treatment_id { FactoryGirl.create(:treatment).id }
    value { values.sample }
    is_taken { value.present? ? true : [true, false].sample }
  end
end
