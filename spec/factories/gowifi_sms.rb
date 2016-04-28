FactoryGirl.define do
  factory :gowifi_sms, :class => 'SmsProfile' do
    phone { Faker::PhoneNumber.phone_number }
  end

end
