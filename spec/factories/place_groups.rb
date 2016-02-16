FactoryGirl.define do
  factory :place_group do
    association :user
    name Faker::Company.name
  end
end
