require 'rails_helper'

RSpec.describe GowifiSms, :type => :model do
  subject { build(:gowifi_sms) }

  it { is_expected.to validate_presence_of :phone }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_length_of(:code).is_equal_to(6) }

  it { is_expected.to callback(:send_sms).after(:create) }

  it 'should initialize proper code' do
    expect(subject.code).to be_a String
    expect(subject.code.length).to eq 6
  end

  context 'creation' do
    let(:place) { create :place }
    let(:sms) { create(:gowifi_sms, place: place) }

    it 'should add job to queue' do
      expect{ sms }.to change(GowifiSmsWorker.jobs, :size).by(1)
    end

    it 'should send message only one at 25 seconds' do
      expect{ sms }.to change(GowifiSmsWorker.jobs, :size).by(1)
      expect{ sms.resend }.to change(GowifiSmsWorker.jobs, :size).by(0)
    end
  end
end
