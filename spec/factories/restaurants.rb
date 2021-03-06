FactoryGirl.define do
  factory :restaurant do
    sequence :name do |n|
      "restaurant #{n}"
    end
    address 'kolla space sabang'
  end

  factory :invalid_restaurant, parent: :restaurant do
    name nil
    address nil
  end
end