class GowifiSmsSendWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sms_send, retry: false, failures: true

  def perform(id)
    record = GowifiSms.find(id)
    sms    = Smsc::Sms.new(ENV['SMSC_LOGIN'], ENV['SMSC_PASSWORD']) # TODO: fork smsc gem to make this in better way

    return development_env_perform(record) if Rails.env.development?

    sms.message(record.code, [record.phone], sender: "#{record.place.name} | GoFriends")
  end

  private
  def development_env_perform(record)
    p '_+_+_+_'
    p "Code: #{record.code}"
    p "Phone: #{record.phone}"
    p "Sender: #{record.place.name} | GoFriends"
  end
end
