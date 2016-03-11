require 'rails_helper'

RSpec.describe Auth do
  let(:place){ create(:place) }

  it { is_expected.to belong_to :place }
  it { is_expected.to belong_to(:resource).dependent(:destroy).autosave(true) }
  it { is_expected.to define_enum_for(:step).with([:primary, :secondary]) }
  it { is_expected.to validate_uniqueness_of(:resource_type).scoped_to([:place_id, :step]) }
  it { is_expected.to validate_presence_of(:redirect_url) }
  it { is_expected.to accept_nested_attributes_for :resource }

  describe "redirect_url validation" do
    it { expect(build(:auth, redirect_url: "fuck")).to_not be_valid }
    it { expect(build(:auth, redirect_url: "http://www.example.com")).to be_valid }
  end

  describe "valid active scope" do 

  end


  describe "Constant values" do
    it "NETWORKS contains proper auth network methods" do
      expect(described_class::NETWORKS).to match({
        vkontakte: 'vkontakte',
        facebook: 'facebook',
        twitter: 'twitter'
      })
    end

    it "ALTERNATIVE contians proper auth alt methods" do
      expect(described_class::ALTERNATIVE).to match({
        poll: 'poll',
        sms: 'sms',
        password: 'password',
        simple: 'simple'
      })
    end

    it "METHODS contains all proper methods" do
      expect(described_class::METHODS).to match([
        "vkontakte",
        "facebook",
        "twitter",
        "poll",
        "sms",
        "password",
        "simple"
      ])
    end
  end

end
