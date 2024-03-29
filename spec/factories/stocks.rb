FactoryGirl.define do
  factory :stock do
    association :place
    image { File.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
  	days [I18n.t('date.day_names').sample]
  end
end
