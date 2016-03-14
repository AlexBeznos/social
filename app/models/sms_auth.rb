class SmsAuth < ActiveRecord::Base
  NAME = Auth::ALTERNATIVE[:sms]

  has_one :auth, as: :resource
end
