require 'rails_helper'

RSpec.describe Auth do
  let(:place){ create(:place) }

  it { is_expected.to belong_to :place }
  it { is_expected.to belong_to(:resource).dependent(:destroy).autosave(true) }
  it { is_expected.to define_enum_for(:step).with([:primary, :secondary]) }
  it { is_expected.to validate_uniqueness_of(:resource_type).scoped_to([:place_id, :step]) }
  it { is_expected.to validate_presence_of(:redirect_url) }
  it { is_expected.to accept_nested_attributes_for :resource }
  it_behaves_like 'with url validation for', :url, :network_profile

  describe "active scope" do
    let(:scoped_auth){ create :auth }
    let(:unscoped_auth){ create :auth, active: false }

    it "resolves scoped auth" do
      expect(Auth.all).to include(scoped_auth)
    end

    it "Doesn`t resolve unscoped auth" do
      expect(Auth.all).to include(unscoped_auth)
    end
  end

  describe "resource_like scope" do
    let(:vk_like_auth){ create :auth }

    it "expect to include 'vk' like resource " do
      expect(Auth.all.resource_like("Vk")).to include(vk_like_auth)
    end
  end

  describe "accept nested attributes" do
    let(:valid_attrs){ attributes_for(:vkontakte_auth) }
    let(:invalid_attrs){ attributes_for(:vkontakte_auth, message:"" ) }

    it "creates resource with valid attributes" do
      expect do
        create(:auth, resource_attributes: valid_attrs )
      end.to change(Auth, :count).by(1)
    end

    it "raise error resource with invalid attributes" do
      expect do
        create(:auth, resource_attributes: invalid_attrs).to have(1).errors_on(:message)
      end
    end
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
