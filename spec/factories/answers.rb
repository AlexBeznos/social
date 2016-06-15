FactoryGirl.define do
  factory :answer do
    content Faker::Hacker.say_something_smart
  end
end
