require 'rails_helper'

RSpec.describe Auth do
  let(:place){ create(:place) }

  it { is_expected.to belong_to :place }
  it { is_expected.to belong_to(:resource).dependent(:destroy).autosave(true) }
  it { is_expected.to define_enum_for(:step).with([:primary, :secondary]) }
  # it { is_expected.to validate_uniqueness_of(:resource_type).scoped_to([:place_id, :step]) } FIXME: currently don`t work
  it { is_expected.to validate_presence_of(:redirect_url) }
  it { is_expected.to accept_nested_attributes_for :resource }
  it_behaves_like 'with url validation for', :url, :network_profile

  describe "notification" do
    let(:place){ create :place, user: general }
    let(:general){ create :user_general, franchisee: franchisee }
    let(:franchisee){ create :user_franchisee }
    let(:auth) { create :auth, place: place }
    before(:each) do
      auth.stub(:network?){ true }
    end

    describe "on modify" do
      it "dot not change state pending" do
        auth.modify!
      end

      it "notifies franchisee" do
        auth.approve!

        expect do
          auth.modify!
        end.to change(franchisee.notifications, :count).by(1)
      end

    end

    context "on unapprove" do
      it "notifies place owner" do
        expect do
          auth.unapprove!
        end.to change(general.notifications, :count).by(1)
      end
    end

  end

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




  describe "Constant values" do
    it "NETWORKS contains proper auth network methods" do
      expect(described_class::NETWORKS).to match({
        vkontakte: 'vkontakte',
        facebook: 'facebook',
        twitter: 'twitter',
        instagram: 'instagram'
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
        "instagram",
        "poll",
        "sms",
        "password",
        "simple"
      ])
    end
  end

end
