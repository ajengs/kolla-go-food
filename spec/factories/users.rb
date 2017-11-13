FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    password 'longpassword'
    password_confirmation 'longpassword'
    gopay 200000
  end

  factory :invalid_user, parent: :user do
    username nil
    password nil
    password_confirmation nil
    gopay -10
  end
end