require 'rails_helper'

RSpec.describe Place do
  subject { build(:place) }

  it { is_expected.to validate_presence_of :ssid }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :template }
  it { is_expected.to validate_inclusion_of(:domen_url).in_array(Place::DOMAIN_LIST) }
  # it { is_expected.to validate_attachment_content_type(:logo).allowing(["image/jpeg", "image/png", "image/gif"]) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to callback(:set_wifi_link_freshnes).before(:save) }
  it { is_expected.to callback(:gen_new_wifi_settings).after(:save) }
  it { is_expected.to callback(:set_wifi_username_password).before(:create) }

  it { is_expected.to have_many(:auths).dependent(:destroy) }
  it { is_expected.to have_many(:visits).class_name('Customer::Visit') }
  it { is_expected.to have_many(:stocks).dependent(:destroy) }
  it { is_expected.to have_many(:reputations).class_name('Customer::Reputation') }
  it { is_expected.to have_many(:social_network_icons).dependent(:destroy) }
  it { is_expected.to have_many(:menu_items).dependent(:destroy) }
  it { is_expected.to have_many(:orders).dependent(:destroy) }
  it { is_expected.to have_many(:banners).dependent(:destroy) }

  it { is_expected.to have_one(:style).dependent(:destroy) }

  describe "when enables scratchcard" do
    let(:place){ create :place }

    it "add errors to scratchcard attr" do
      place.update(scratchcard: true)
      expect(place).to have(1).error_on(:scratchcard)
    end
  end

  describe 'constants' do
    it 'matches DOMAIN_LIST' do
      expect(Place::DOMAIN_LIST).to match([ "gofriends.com.ua", "go-friends.ru", "gofriends.by", "gofriends.kz" ])
    end
  end

  describe "Banners" do
    it "can't show other banners if city is not set" do
      place = build(:place, city: "", display_other_banners: true)
      expect(place).to_not be_valid
    end

    it "can't display it's banners in other places if city is not set" do
      place = build(:place, city: "", display_my_banners: true)
      expect(place).to_not be_valid
    end
  end
end
