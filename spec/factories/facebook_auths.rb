FactoryGirl.define do
  factory :facebook_auth do
    message Faker::Lorem.sentence
    message_url Faker::Internet.url
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'fixtures', 'docker.png')) }
    redirect_url Faker::Internet.url
  end

end
