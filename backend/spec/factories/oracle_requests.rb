FactoryBot.define do
  factory :oracle_request do
    age { 30 }
    sequence(:token) { |n| "oracle-token-#{n}" }
  end
end
