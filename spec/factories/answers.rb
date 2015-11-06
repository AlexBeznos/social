FactoryGirl.define do
  factory :answer do
    content "MyString"
    association :poll
  end
end
