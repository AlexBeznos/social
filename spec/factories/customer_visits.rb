FactoryGirl.define do
  factory :customer_visit, :class => 'Customer::Visit' do
    customer_network_profile_id 1
place_id 1
  end

end
