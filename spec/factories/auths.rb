FactoryGirl.define do
  factory :auth do

    active true
    redirect_url Faker::Internet.url('example.com')
    resource_type "VkontakteAuth"
end
