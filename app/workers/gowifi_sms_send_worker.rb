class GowifiSmsSendWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :sms_send, :retry => false, :failures => true

  def perform(id)
    record = GowifiSms.find(id)
    sms = Smsc::Sms.new(ENV['SMSC_LOGIN'], ENV['SMSC_PASSWORD']) # TODO: fork smsc gem to make this in better way
    sms.message(record.code, [record.phone], sender: "#{record.place.name} | GoFriends")
  rescue ActiveRecord::RecordNotFound
  end
end