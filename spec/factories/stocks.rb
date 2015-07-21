FactoryGirl.define do
  factory :stock do
    association :place
    image { Rack::Test::UploadedFile.new("#{::Rails.root}/app/assets/images/wifi/default/facebook.png", "image/png") }
  end

end
