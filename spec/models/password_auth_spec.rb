require 'rails_helper'

RSpec.describe PasswordAuth do
  it { is_expected.to have_one(:auth) }
  it { is_expected.to validate_presence_of :password }

  it "has proper name" do
    expect(described_class::NAME).to eq('password')
  end
end
