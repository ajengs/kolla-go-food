FactoryGirl.define do
  factory :category do
    # name { Faker::Dessert.variety }
    sequence :name do |n|
      "category#{n}"
    end
  end

  factory :invalid_category, parent: :category do
    name nil
  end
end