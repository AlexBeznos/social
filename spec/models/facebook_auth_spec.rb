require "rails_helper"

RSpec.describe FacebookAuth, :type => :model do
  it { is_expected.to have_one :auth}
  it { is_expected.to validate_presence_of(:image)}
  it { is_expected.to validate_presence_of(:message)}
  it { is_expected.to validate_presence_of(:message_url)}
  it_behaves_like 'with url validation for', :message_url

  it "has proper name" do
    expect(described_class::NAME).to eq('facebook')
  end
end
