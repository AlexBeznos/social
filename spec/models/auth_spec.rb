require 'rails_helper'

RSpec.describe Auth, :type => :model do
  let(:place){ create(:place) }

  it{ is_expected.to belong_to :place }

  describe "default scope" do
    context "out of scope values" do
      before do
        create(:vk_auth_type, active: false)
        create(:facebook_auth_type, active: false)
      end

      it{ expect(Auth.all).to be_empty }
    end

    context "values in scope" do
      before do
        create(:vk_auth_type)
        create(:facebook_auth_type)
      end

      it{ expect(Auth.all.count).to be(2) }
    end
  end

  describe "belongs_to resource" do
    let(:vk){ create(:vk_auth) }
    let(:auth){ create(:auth, resource: vk) }
    subject{ auth }

    it{ is_expected.to respond_to(:resource) }
    it{ expect(subject.resource).to be(vk) }
  end

  describe "uniqueness scope" do
    it "allows auth with unique type" do
      is_expected.to allow_value(:vk).for(:resource_type)
    end

    it "don`t allows auth with no unique type" do
      place.auths << create(:vk_auth_type)
      place.auths << create(:auth)
      expect(place.auths.last).to_not allow_value("VkAuth").for(:resource_type)
    end
  end

  describe "redirect_url validation" do
    it{ is_expected.to validate_presence_of :redirect_url }
    it { expect(build(:auth, redirect_url: "fuck")).to_not be_valid }
    it { expect(build(:auth, redirect_url: "http://www.example.com")).to be_valid }
  end

  describe "accept nested attribute" do
    context "with valid attributes" do
      it{ expect { create(:vk_auth_type, resource_attributes: attributes_for(:vk_auth)) }.to change(Auth, :count).by(1) }
    end

    context "with invalid attributes" do
      let(:invalid_auth){ build(:vk_auth_type, resource_attributes: attributes_for(:vk_auth, message: "")) }

      it{ expect(invalid_auth).to have(1).error_on("resource.message") }
    end
  end

  describe "Constant values" do
    it "NETWORKS contains proper auth network methods" do
      expect(Auth::NETWORKS).to include({
        vk: 'vk',
        facebook: 'facebook',
        twitter: 'twitter'
      })
    end

    it "ALTERNATIVE contians proper auth alt methods" do
      expect(Auth::ALTERNATIVE).to include({
        poll: 'poll',
        sms: 'sms',
        password: 'password'
      })
    end

    it "METHODS contains all proper methods" do
      expect(Auth::METHODS).to include(
        "vk",
        "facebook",
        "twitter",
        "poll",
        "sms",
        "password"
      )
    end
  end

end
