FactoryGirl.define do
  factory :menu_item do
    association :place
    name "Item name"
    price 20
  end

end
