FactoryGirl.define do
  factory :place do
    association :user
    name "Cafe"
    template "default"
  end

end
