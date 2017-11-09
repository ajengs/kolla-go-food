FactoryGirl.define do
  factory :review do
    name { Faker::Internet.user_name }
    title { Faker::Book.title }
    description { Faker::Matz.quote }
    association :reviewable, factory: :food
  end

  factory :invalid_review, parent: :review  do
    name nil
    title nil
    description nil
  end
end
