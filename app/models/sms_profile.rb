class SmsProfile < ActiveRecord::Base
  has_one :profile, as: :resource

  before_save :set_sms_code
  after_create :send_sms

  validates :phone, presence: true
  validates :code, uniqueness: true

  def send_sms
    GowifiSmsSendWorker.perform_async(id)
  end

  def resend_sms
    if 10.seconds.ago > updated_at
      send_sms
      self.touch
    end
  end

  def self.prepare_params(params)
    { phone: params[:phone] }
  end

  private

  def set_sms_code
    self.code = SecureRandom.random_number.to_s[-6, 6]
    set_sms_code if SmsProfile.find_by(code: code)
  end
end
