class GowifiSms < ActiveRecord::Base

  belongs_to :place

  default_value_for :code do
    SecureRandom.random_number.to_s[-6, 6]
  end

  validates :phone, :place_id, presence: true
  validates :phone, phone: true
  validates :code, length: { is: 6 }

  after_commit :send_sms, on: :create
  after_commit :remove_gowifi_sms_record, on: :create

  def send_sms
    GowifiSmsSendWorker.perform_async(id)
  end

  def resend_sms
    if 10.seconds.ago > updated_at
      send_sms
      self.touch
    end
  end

  private
  def remove_gowifi_sms_record
    GowifiSmsRemoveWorker.perform_in(1.hours, id)
  end
end
