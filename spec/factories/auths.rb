FactoryGirl.define do
  factory :auth do

    active true
    redirect_url Faker::Internet.url('example.com')

    factory :vk_auth_type do
      resource_type "VkAuth"
    end

    factory :facebook_auth_type do
      resource_type "FacebookAuth"
    end
  end
end
