require 'rails_helper'

RSpec.describe Place do
  subject { build(:place) }

  # FIXME: validate_presence_of :name test not passes because of using name in slug
  # generation(slug generates by before_validation hook),
  # we need to figure out why.
  # it { is_expected.to validate_presence_of :name }


  it { is_expected.to validate_presence_of :ssid }
  it { is_expected.to validate_presence_of :template }
  it { is_expected.to validate_inclusion_of(:domen_url).in_array(Place::DOMAIN_LIST) }
  # it { is_expected.to validate_attachment_content_type(:logo).allowing("image/jpeg", "image/png", "image/gif") }
  it { is_expected.to belong_to(:user) }
  # it { is_expected.to have_attached_file(:logo) }
  it { is_expected.to callback(:set_wifi_link_freshnes).before(:save) }
  it { is_expected.to callback(:gen_new_wifi_settings).after(:save) }
  it { is_expected.to callback(:set_password).before(:validation).if('enter_by_password') }
  it { is_expected.to have_many(:auths) }
  it { is_expected.to have_many(:messages) }
  it { is_expected.to have_many(:visits).class_name('Customer::Visit') }
  it { is_expected.to have_many(:stocks) }
  it { is_expected.to have_many(:reputations).class_name('Customer::Reputation') }
  it { is_expected.to have_many(:social_network_icons) }
  it { is_expected.to have_many(:menu_items) }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:polls) }
  it { is_expected.to have_many(:gowifi_sms) }

  it { is_expected.to have_one(:style) }
  it { is_expected.to callback(:set_wifi_username_password).before(:create) }

  describe "Wifi settings link" do
    it "has valid value" do
      place = build(:place, wifi_settings_link: "http://google.com")

      expect(place).to be_valid
    end

    it "has invalid value" do
      place = build(:place, wifi_settings_link: "google.com")
      place.valid?
      expect(place.errors.messages[:wifi_settings_link]).to include(I18n.t('models.errors.validations.wrong_link_format'))
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
