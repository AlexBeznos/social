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

  describe "state machine" do
    let(:auth) { create :auth }

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

  describe "mark as unapproved" do
    let(:general){ create :user_general, franchisee: franchisee }
    let(:franchisee) { create :user_franchisee }
    let(:place){ create :place, user: general }
    let(:network){ create :auth, place: place, resource: create(:vkontakte_auth) }
    let(:alternative){ create :auth, place: place, resource: create(:simple_auth) }

    context "when auth is network" do
      it "Add new notification to franchisee" do
        expect do
          network.mark_as_unapproved!
        end.to change(franchisee.notifications, :count).by(1)
      end
    end

    context "when auth is alternative" do
      it "Add new notification to franchisee" do
        expect do
          alternative.mark_as_unapproved!
        end.to_not change(franchisee.notifications, :count)
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
