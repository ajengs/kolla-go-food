FactoryGirl.define do
  factory :category do
    name { Faker::Dessert.variety }
  end

  factory :invalid_category do
    name nil
  end
end