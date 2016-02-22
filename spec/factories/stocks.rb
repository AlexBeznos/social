FactoryGirl.define do
  factory :stock do
    association :place
    image { Rack::Test::UploadedFile.new("#{::Rails.root}/spec/fixtures/image.jpg", "image/jpg") }
  	day I18n.t('date.day_names').sample
  end
end
