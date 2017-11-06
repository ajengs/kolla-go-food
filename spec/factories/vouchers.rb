# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voucher do
    code "GOWEEKND"
    amount 10.0
    unit "percent"
    valid_from "2017-11-01"
    valid_through "2017-11-10"
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
