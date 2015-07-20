require 'rails_helper'

RSpec.describe Place, :type => :model do
  # Can't figure out wtf error of this first 3 validations. TypeError: can't dup NilClass . Need checking in another environment
  it { should validate_presence_of :name }
  it { should validate_presence_of :template }
  it { should validate_attachment_content_type(:logo).allowing("image/jpeg", "image/png", "image/gif") }
  it { should belong_to(:user) }
  it { should have_attached_file(:logo) }
  it { is_expected.to callback(:set_wifi_link_freshnes).before(:save) }
  it { is_expected.to callback(:gen_new_wifi_settings).after(:save) }
  it { is_expected.to callback(:set_password).before(:validation).if('enter_by_password') }
  it { should have_many(:messages) }
  it { should have_many(:visits).class_name('Customer::Visit') }
  it { should have_many(:stocks) }
  it { should have_many(:reputations).class_name('Customer::Reputation') }
  it { should have_many(:social_network_icons) }
  it { should have_one(:style) }

  describe "Wifi settings link" do
    it "has valid value" do
      place = build(:place, wifi_settings_link: "http://google.com")

      expect(place).to be_valid
    end

    it "has invalid value" do
      place = build(:place, wifi_settings_link: "google.com")
      place.valid?
      expect(place.errors.messages[:wifi_settings_link]).to include("Невірний формат посилання")
    end
  end

  describe "Wifi username and password" do

    let(:place) { create(:place) }

    it { is_expected.to callback(:set_wifi_username_password).before(:save) }

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
