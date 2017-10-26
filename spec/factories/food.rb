FactoryGirl.define do
  factory :food do
    name { Faker::Food.dish }
    description { "Made by #{Faker::Food.ingredient} mixed with #{Faker::Food.ingredient}" }
    price 10000.0
  end

  factory :invalid_food, parent: :food  do
    name nil
    description nil
    price 10000.0
  end
end
