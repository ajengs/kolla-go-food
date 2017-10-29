FactoryGirl.define do
  factory :category do
    name { Faker::Dessert.variety }
  end
end