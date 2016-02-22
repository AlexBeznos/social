FactoryGirl.define do
  factory :banner do
    name "Test"
    number_of_views 1
    content { File.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
    association :place
  end
end
