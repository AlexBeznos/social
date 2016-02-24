FactoryGirl.define do
  factory :gowifi_sms, :class => 'GowifiSms' do
    phone { Faker::PhoneNumber.phone_number }
    association :place
  end

end
