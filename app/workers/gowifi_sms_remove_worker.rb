class GowifiSmsRemoveWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :sms_remove, :retry => false, :failures => true

  def perform(id)
    record = GowifiSms.find(id)
    record.destroy
  end
end
