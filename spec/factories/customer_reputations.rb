FactoryGirl.define do
  factory :reputation, :class => Customer::Reputation do
    association :place
    association :customer
    score 1000
  end

end
