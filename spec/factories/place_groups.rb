FactoryGirl.define do
  factory :place_group do
    name "TestGroup"

    trait :with_places do
      transient do
        number_of_places 5
      end

      after(:create) do |place_group, evaluator|
        create_list(:place, evaluator.number_of_places, place_group: place_group, user: place_group.user)
      end
    end
  end
end
