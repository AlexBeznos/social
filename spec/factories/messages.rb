FactoryGirl.define do
  factory :message do
    association :place
    # association :social_network
    message "Hello!"
    image_file_name "picture.jpg"
    social_network_id 2
  end

end
