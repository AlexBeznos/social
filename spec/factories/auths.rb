FactoryGirl.define do
  factory :auth do

    active true
    redirect_url "http://www.apple.com/"
    resource_type "VkontakteAuth"
  end
end
