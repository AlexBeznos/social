FactoryGirl.define do
  factory :network_profile, :class => Customer::NetworkProfile do
    url Faker::Internet.url
    association :customer
    association :social_network
  end

end
