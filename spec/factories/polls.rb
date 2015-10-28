FactoryGirl.define do
  factory :poll do
    question "MyText"
    association :place
  end
end
