class SmsProfile < ActiveRecord::Base
  def self.prepare_params(credentials)
    {
      code: credentials['code'],
      number: credentials['phone']
    }
  end
end
