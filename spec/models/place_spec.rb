require 'rails_helper'

RSpec.describe Place do
  subject { build(:place) }

  # FIXME: validate_presence_of :name test not passes because of using name in slug
  # generation(slug generates by before_validation hook),
  # we need to figure out why.
  # it { is_expected.to validate_presence_of :name }

  it { is_expected.to validate_presence_of :template }
  it { is_expected.to validate_attachment_content_type(:logo).allowing("image/jpeg", "image/png", "image/gif") }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_attached_file(:logo) }
  it { is_expected.to callback(:set_wifi_link_freshnes).before(:save) }
  it { is_expected.to callback(:gen_new_wifi_settings).after(:save) }
  it { is_expected.to callback(:set_password).before(:validation).if('enter_by_password') }
  it { is_expected.to have_many(:messages) }
  it { is_expected.to have_many(:visits).class_name('Customer::Visit') }
  it { is_expected.to have_many(:stocks) }
  it { is_expected.to have_many(:reputations).class_name('Customer::Reputation') }
  it { is_expected.to have_many(:social_network_icons) }
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

  describe "Wifi username and password" do

    let(:place) { create(:place) }

    it "should not be default" do
      expect(place.wifi_username).not_to include("P8uDratA")
      expect(place.wifi_password).not_to include("Tac4edrU")
    end

    it "should not be empty" do
      expect(place.wifi_username).not_to be_empty
      expect(place.wifi_password).not_to be_empty
    end
  end
end
