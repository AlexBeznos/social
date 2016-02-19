FactoryGirl.define do
  factory :banner do
    name "Test"
    number_of_views 1
    content { Rack::Test::UploadedFile.new("#{::Rails.root}/spec/fixtures/image.jpg", "image/jpg") }
    association :place
  end
end
