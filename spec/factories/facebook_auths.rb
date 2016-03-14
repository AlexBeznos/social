FactoryGirl.define do
  factory :facebook_auth do
    message Faker::Hacker.say_something_smart
    message_url Faker::Internet.url("example.com")
    image { File.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
  end
end
