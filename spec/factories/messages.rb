FactoryGirl.define do
  factory :message do
    with_message_id :place
    with_message_type "Place"
    social_network_id 1
    message { Faker::Lorem.paragraph }
    image { Rack::Test::UploadedFile.new("#{::Rails.root}/spec/fixtures/image.jpg", "image/jpg") }
    # redirect_url 'http://hello.com'   NOTE: IT`S FROM OTHER TASK FROM BRANCH "redirect" AND IT`S APPEARED HERE SOMEHOW
  end

end
