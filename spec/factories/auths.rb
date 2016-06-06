FactoryGirl.define do
  factory :auth do

    active true
    redirect_url "http://pikabu.ru/"
    resource_type "VkontakteAuth"

    factory :alternative_auth do
      resource_type "SimpleAuth"
    end
  end
end
