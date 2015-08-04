FactoryGirl.define do
  factory :visit, :class => Customer::Visit do
    association :network_profile
    association :place
    association :customer
  end

end
