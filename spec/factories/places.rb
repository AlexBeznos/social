FactoryGirl.define do
  factory :place do
    association :user
    name Faker::Company.name
    template "default"
    wifi_username SecureRandom.hex(6)
    wifi_password SecureRandom.hex(6)
    reputation_on true
    score_amount 20
    domen_url "gofriends.com.ua"

    trait :in_group do
        association :place_group
    end
  end
end
