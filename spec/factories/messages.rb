FactoryGirl.define do
  factory :message do
    with_message_id :place
    with_message_type "Place"
    # association :social_network
    message "Hello!"
    image_file_name "picture.jpg"
    social_network_id 2
    redirect_url 'http://hello.com'
  end

end
