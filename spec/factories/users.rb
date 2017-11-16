FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    password 'longpassword'
    password_confirmation 'longpassword'
    gopay 200000
    # after(:create) do |user|
    #   FactoryGirl.create_list(:role, 1, user: user)
    # end
    roles { build_list :role, 1 }
  end

  factory :invalid_user, parent: :user do
    username nil
    password nil
    password_confirmation nil
    gopay -10
  end                                                                                                                                                                               
end