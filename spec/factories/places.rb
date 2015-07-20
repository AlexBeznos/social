FactoryGirl.define do
  factory :place do
    association :user
    name "Cafe"
    template "default"
    wifi_username SecureRandom.hex(6)
    wifi_password SecureRandom.hex(6)
  end

end
