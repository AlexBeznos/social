class SmsProfile < ActiveRecord::Base
  has_one :profile, as: :resource
  has_many :visits, as: :account, class_name: "Customer::Visit"

  validates :phone, presence: true
  validates :phone, phone: true

  before_save :set_sms_code

  def self.prepare_params(params)
    { phone: params[:phone] }
  end

  private

  def set_sms_code
    begin
      self.code = SecureRandom.random_number.to_s[-6, 6]
    end until SmsProfile.where(code: code).empty?
  end
end
