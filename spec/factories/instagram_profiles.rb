FactoryGirl.define do
  factory :instagram_profile do
    nickname Faker::Internet.user_name
    name Faker::Name.name
    url Faker::Internet.url
    uid SecureRandom.random_number(1_000_000)
    access_token SecureRandom.hex

    after(:create) do |profile|
      create(:profile, resource: profile)
    end
  end
end
