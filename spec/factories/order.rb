FactoryGirl.define do
  factory :order do
    name { Faker::Name.name }
    address 'Pasaraya Blok M, Melawai, South Jakarta City, Jakarta'
    email { Faker::Internet.email }
    payment_type "Cash"
    voucher_code nil
    association :voucher
    association :user
    # latitude -6.243758
    # longitude 106.800689
  end

  factory :invalid_order, parent: :order do
    name nil
    address nil
    email nil
    payment_type nil
  end
end