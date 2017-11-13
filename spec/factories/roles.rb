FactoryGirl.define do
  factory :role do
    sequence :name do |n|
      "role #{n}"
    end
  end

  factory :invalid_role, parent: :role do
    name nil
  end
end