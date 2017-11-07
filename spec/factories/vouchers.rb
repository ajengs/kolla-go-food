# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voucher do
    code { Faker::Name.name }
    amount 10.0
    unit "Percent"
    valid_from Date.today
    valid_through 5.days.from_now
    max_amount 10000
  end

  factory :invalid_voucher, parent: :voucher do
    code nil
    amount nil
    unit nil
    valid_from nil
    valid_through nil
    max_amount nil
  end
end
