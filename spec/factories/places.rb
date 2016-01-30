FactoryGirl.define do
  factory :place do
    association :user
    name Faker::Company.name
    template "default"
    ssid Faker::Lorem.word
    wifi_username SecureRandom.hex(6)
    wifi_password SecureRandom.hex(6)
    reputation_on true
    score_amount 20
    domen_url "gofriends.com.ua"
  end

end
