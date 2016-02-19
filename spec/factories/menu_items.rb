FactoryGirl.define do
  factory :menu_item do
    association :place
    name { Faker::Lorem.sentence }
    price 100
    image { Rack::Test::UploadedFile.new("#{::Rails.root}/spec/fixtures/image.jpg", "image/jpg") }
  end

end
