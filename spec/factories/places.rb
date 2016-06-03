FactoryGirl.define do
  factory :place do
    association :user
    active true
    mfa false
    demo true
    name { Faker::Company.name }
    ssid { Faker::Lorem.word[0..7] }
    score_amount 20
    domen_url { Place::DOMAIN_LIST.sample }
    created_at { Date.today }

    factory :last_week_place do
      before(:create) do
        Timecop.travel(Date.today - 5.days)
      end

      after(:create) do
        Timecop.return
      end
    end

    factory :last_month_place do
      before(:create) do
        Timecop.travel(Date.today - 3.weeks)
      end

      after(:create) do
        Timecop.return
      end
    end
  end
end
