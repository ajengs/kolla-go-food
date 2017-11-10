# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :food_tag do
    association :food
    association :tag
  end
end
