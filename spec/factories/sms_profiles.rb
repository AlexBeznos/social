FactoryGirl.define do
  factory :sms_profile do
    phone Faker::PhoneNumber.phone_number

    after(:create) do |profile|
      create(:profile, resource: profile)
    end
  end
end
