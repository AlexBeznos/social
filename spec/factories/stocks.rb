FactoryGirl.define do
  factory :stock do
    association :place
    place_id 111
    image { Rack::Test::UploadedFile.new("#{::Rails.root}/tmp/image.png", "image/png") }
  end

end