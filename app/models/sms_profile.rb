class SmsProfile < ActiveRecord::Base
  has_one :profile, as: :resource
  has_many :visits, as: :account, class_name: "Customer::Visit"

  validates :phone, presence: true
  validates :phone, phone: true
  validates :code, uniqueness: true

  before_save :set_sms_code
  after_commit :send_sms, on: :create

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
