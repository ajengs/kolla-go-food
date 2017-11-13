FactoryGirl.define do
  factory :role do
    name 'administrator'
  end

  factory :invalid_role, parent: :role do
    name nil
  end
end