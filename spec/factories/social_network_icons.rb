FactoryGirl.define do
  factory :social_network_icon do
    association :place
    association :style
    icon { File.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
    network_name { Auth::NETWORKS.values.sample }
  end
end
