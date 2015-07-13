FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    sequence(:email) {|n| "username#{n}@test.com"}
    phone '+380951112233'
    password 'qwerty'
    password_confirmation 'qwerty'
    user_id 1

    factory :user_general do
      group 0
    end

    factory :user_franchisee do
      group 1
    end

    factory :user_admin do
      group 2
    end
  end

end
