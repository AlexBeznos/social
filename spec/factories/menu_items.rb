FactoryGirl.define do
  factory :menu_item do
    association :place
    name { Faker::Lorem.sentence }
    price 100
    image { File.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
  end

end
