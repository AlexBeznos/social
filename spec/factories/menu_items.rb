FactoryGirl.define do
  factory :menu_item do
    association :place
    name "Item name"
    price 100
  end

end
