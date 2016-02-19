FactoryGirl.define do
  factory :customer do
    first_name { Faker::Name.first_name }
  end

  factory :full_name_customer, class: Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
