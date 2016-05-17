FactoryGirl.define do
  factory :order do
    association :place
    association :customer

    factory :last_week_order do
      before(:create) do
        Timecop.travel(Date.today - 6.days)
      end

      after(:create) do
        Timecop.return
      end
    end

    factory :last_month_order do
      before(:create) do
        Timecop.travel(Date.today - 3.weeks)
      end

      after(:create) do
        Timecop.return
      end
    end
  end
end
