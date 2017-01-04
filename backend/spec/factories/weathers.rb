FactoryGirl.define do
  factory :weather do
    date "MyString"
    postal_code "MyString"
    icon "MyString"
    temperature_min 1.5
    temperature_max 1.5
    precip_intensity 1.5
    pressure 1.5
    humidity 1.5
  end
end
