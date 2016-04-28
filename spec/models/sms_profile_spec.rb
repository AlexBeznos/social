require 'rails_helper'

RSpec.describe SmsProfile do
  subject { build(:gowifi_sms) }

  it { is_expected.to validate_presence_of :phone }
  it { is_expected.to callback(:set_sms_code).before(:save) }
end
