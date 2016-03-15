FactoryGirl.define do
  factory :auth do

    active true
    redirect_url Faker::Internet.url
    resource_type "VkontakteAuth"
  end
end
