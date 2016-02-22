FactoryGirl.define do
  factory :social_network_icon do
    association :place
    association :social_network
    association :style
    icon { File.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
  end
end
