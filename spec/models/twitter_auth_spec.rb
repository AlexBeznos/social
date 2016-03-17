require "rails_helper"

RSpec.describe TwitterAuth, :type => :model do
  it { is_expected.to have_one :auth}
  it { is_expected.to validate_presence_of(:image)}
  it { is_expected.to validate_presence_of(:message)}
  it_behaves_like 'with url validation for', :message_url
  describe "twitter message length validator" do
    context "message + url is too long" do
      it "makes record invalid" do
        auth = build_stubbed(:twitter_auth, message: Faker::Lorem.characters(141))
        expect(auth).not_to be_valid
      end
    end

    context "message + url have proper length" do
      it "leave record valdi" do
        auth = build_stubbed(:twitter_auth)
        expect(auth).to be_valid
      end
    end
  end

  it "has proper name" do
    expect(described_class::NAME).to eq('twitter')
  end
end
