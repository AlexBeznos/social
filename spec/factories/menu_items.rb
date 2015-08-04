FactoryGirl.define do
  factory :menu_item do
    association :place
    name "Item name"
    price 100
    image_file_name "picture.jpg"
  end

end
