FactoryGirl.define do
  factory :password_profile do
    after(:create) do |profile|
      create(:profile, resource: profile)
    end
  end
end
