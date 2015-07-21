FactoryGirl.define do
  factory :place do
    association :user
    name Faker::Company.name
    template "default"
    wifi_username SecureRandom.hex(6)
    wifi_password SecureRandom.hex(6)
  end

end
