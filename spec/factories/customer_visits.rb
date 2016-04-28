FactoryGirl.define do
  factory :visit, :class => Customer::Visit do
    association :place
    association :customer
  end
end
