class Customer::Session < ActiveRecord::Base
  include ConditionalQueries

  belongs_to :place
  belongs_to :customer
  belongs_to :device

  def device_remembered?
    if device && device.remembering_expires_at > DateTime.now - 90.days
      return true
    end

    return false
  end

  def remember_device!
    device.update(remembering_expires_at: DateTime.now - 90.days)
  end
end
