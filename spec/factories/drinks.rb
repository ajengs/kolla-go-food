FactoryGirl.define do
  factory :drink do
    name { Faker::Food.dish }
    description { "Made by #{Faker::Food.ingredient} mixed with #{Faker::Food.ingredient}" }
    price 10000.0
    image_url 'orange-juice.jpg'

    association :category
  end

  factory :invalid_drink, parent: :drink do
    name nil
    description nil
    price 10000.0
  end
end