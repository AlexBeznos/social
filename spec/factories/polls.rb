FactoryGirl.define do
  factory :poll do
    question { Faker::Lorem.sentence }
    association :place
  end
end
