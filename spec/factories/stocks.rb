FactoryGirl.define do
  factory :stock do
    association :place
    url { Faker::Internet.url }
    image { File.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
  	day I18n.t('date.day_names').sample
  end
end
