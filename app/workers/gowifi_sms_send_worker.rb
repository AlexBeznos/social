class GowifiSmsSendWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sms_send, retry: false, failures: true

  def perform(id, place_id)
    sms_profile = SmsProfile.find(id)
    place       = Place.find(place_id)
    sms         = Smsc::Sms.new(ENV['SMSC_LOGIN'], ENV['SMSC_PASSWORD']) # TODO: fork smsc gem to make this in better way

    return development_env_perform(sms_profile, place) if Rails.env.development?

    sms.message(sms_profile.code, [sms_profile.phone], sender: "#{place.name} | GoFriends")
  end

  private
  def development_env_perform(sms_profile, place)
    p '_+_+_+_'
    p "Code: #{sms_profile.code}"
    p "Phone: #{sms_profile.phone}"
    p "Sender: #{place.name} | GoFriends"
  end
end
