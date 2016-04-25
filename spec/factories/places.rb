FactoryGirl.define do
  factory :place do
    association :user
    active true
    name { Faker::Company.name }
    template "default"
    ssid { Faker::Lorem.word[0..7] }
    score_amount 20
    domen_url { Place::DOMAIN_LIST.sample }
    created_at { Date.today }
  end

end
