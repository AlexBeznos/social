require 'rails_helper'

RSpec.describe SmsAuth do
  it { is_expected.to have_one(:auth) }

  it "has proper name" do
    expect(described_class::NAME).to eq('sms')
  end
end
