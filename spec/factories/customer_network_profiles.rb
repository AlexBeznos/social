FactoryGirl.define do
  factory :network_profile, :class => Customer::NetworkProfile do
    association :customer
    association :social_network
  end

end
