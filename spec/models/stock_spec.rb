require 'rails_helper'

RSpec.describe Stock do
  it { is_expected.to belong_to(:place) }
  # it { is_expected.to have_attached_file(:image) }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_presence_of :day }
  # it { is_expected.to validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }
  it { is_expected.to callback(:normalize_day).before(:save) }

  describe "url" do
    it "has valid value" do
      stock = build(:stock, url: "http://google.com")

      expect(stock).to be_valid
    end

    it "has invalid value" do
      stock = build(:stock, url: "google.com")
      stock.valid?
      expect(stock.errors.messages[:url]).to include(I18n.t('models.errors.validations.wrong_link_format'))
    end
  end

  describe "day" do
    it "is normalized" do
      day =  I18n.t('date.day_names').sample
      stock = build(:stock, day: day)
      stock.save
      expect(stock.day).to eq I18n.t('date.day_names', :locale => :en)[I18n.t('date.day_names').index(day)]
    end
  end
end
