FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    sequence(:email) {|n| "username#{n}@test.com"}
    # email Faker::Internet.safe_email
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

    trait :with_places do
      ignore do
        number_of_places 5
      end

      after(:create) do |user, evaluator|
        create_list(:place, evaluator.number_of_places, user: user)
      end
    end
  end
end
