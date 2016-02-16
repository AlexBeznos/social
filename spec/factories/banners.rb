FactoryGirl.define do
  factory :banner do
    name "Test"
    number_of_views 1
    content {Rack::Test::UploadedFile.new("#{::Rails.root}/app/assets/images/wifi/default/facebook.png", "image/png")}
    association :place
  end
end
