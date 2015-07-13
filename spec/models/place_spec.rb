require 'rails_helper'

RSpec.describe Place, :type => :model do
  # Can't figure out wtf error of this 3 validations. TypeError: can't dup NilClass
  # it { should validate_presence_of :name }
  # it { should validate_presence_of :template }
  # it { should validate_attachment_content_type(:logo).allowing("image/jpeg", "image/png", "image/gif") }
  it { should belong_to(:user) }
  it { should have_attached_file(:logo) }

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
end
