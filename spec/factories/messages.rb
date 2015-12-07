FactoryGirl.define do
  factory :message do
    with_message_id :place
    with_message_type "Place"
    # association :social_network
    message "Hello!"
    image_file_name "picture.jpg"
    social_network_id 2

    trait :group_message do
      with_message_id :place_group
      with_message_type "PlaceGroup"
    end
  end
end
