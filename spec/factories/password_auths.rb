FactoryGirl.define do
  factory :password_auth do
    password Faker::Lorem.characters(10)
  end
end
