require 'rails_helper'

RSpec.describe SmsProfile do
  subject { build(:gowifi_sms) }

  it { is_expected.to validate_presence_of :phone }
  it { is_expected.to callback(:send_sms).after(:create) }

  context 'creation' do
    let(:sms) { create(:gowifi_sms) }

    it 'should add job to sms_send queue' do
      expect{ sms }.to change(GowifiSmsSendWorker.jobs, :size).by(1)
    end

    it 'should send message only one at 25 seconds' do
      expect{ sms }.to change(GowifiSmsSendWorker.jobs, :size).by(1)
      expect{ sms.resend_sms }.to change(GowifiSmsSendWorker.jobs, :size).by(0)
    end
  end
end
