FactoryGirl.define do
  factory :food do
    name { Faker::Food.dish }
    description 'Betawi style steamed rice cooked in coconut milk'
    price 10000.0
  end
end