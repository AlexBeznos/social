FactoryGirl.define do
  factory :twitter_auth do
    message Faker::Lorem.characters(40)
    message_url Faker::Internet.url("example.com")
    image { File.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
  end
end
