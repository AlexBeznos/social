FactoryGirl.define do
  factory :social_network_icon do
    association :place
    association :social_network
    association :style
    icon { Rack::Test::UploadedFile.new("#{::Rails.root}/spec/fixtures/image.jpg", "image/jpg") }
  end
end
