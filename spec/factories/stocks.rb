FactoryGirl.define do
  factory :stock do
    association :place
    image { Rack::Test::UploadedFile.new("#{::Rails.root}/app/assets/images/wifi/default/facebook.png", "image/png") }
  	# Not sure if this is the right way, since we need to generate only day of the week, 
  	# not the full date, but since there is no check for entered data for this field 
  	# (it can hold any string) - this behaviour is totally expected. Need to either add some 
  	# format validation for the field or just leave it as is 
  	day I18n.t('date.day_names').sample
  end
end