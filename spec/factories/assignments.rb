FactoryGirl.define do
  factory :assignment do
    association :user
    association :role
  end

  factory :invalid_assignment, parent: :assignment do
    user_id nil
    role_id nil
  end
end
