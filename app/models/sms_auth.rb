class SmsAuth < ActiveRecord::Base
  NAME = Auth::ALTERNATIVE[:sms]

  has_one :auth, as: :resource

  default_value_for :code do
    SecureRandom.random_number.to_s[-6, 6]
  end

  validates :message, presence: true
  validates :phone, phone: true
  validates :code, length: { is: 6 }

  after_create :send_sms
  after_create :remove_gowifi_sms_record

  def send_sms
    GowifiSmsSendWorker.perform_async(id)
  end

  def resend_sms
    if 25.seconds.ago > updated_at
      send_sms
      self.touch
    end
  end

  private
  def remove_gowifi_sms_record
    GowifiSmsRemoveWorker.perform_in(1.hours, id)
  end

end
