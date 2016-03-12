FactoryGirl.define do
  factory :poll_auth do
    question Faker::Hacker.say_something_smart
  end
end
