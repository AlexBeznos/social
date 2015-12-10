class GowifiSms < ActiveRecord::Base

  belongs_to :place

  default_value_for :code do
    SecureRandom.random_number.to_s[-6, 6]
  end

  validates :phone, :place_id, presence: true
  validates :phone, phone: true
  validates :code, length: { is: 6 }

  after_create :send_sms

  def send_sms
    GowifiSmsWorker.perform_async(id)
  end

  def resend_sms
    if 25.seconds.ago > updated_at
      send_sms
      self.touch
    end
  end
end
