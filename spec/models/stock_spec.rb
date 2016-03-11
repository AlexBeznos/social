require 'rails_helper'

RSpec.describe Stock do
  it { is_expected.to belong_to(:place) }
  it { is_expected.to validate_presence_of :image }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_presence_of :day }
  # it { is_expected.to validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }
  it { is_expected.to callback(:normalize_day).before(:save) }

  it_behaves_like 'with url validation for', :url, :network_profile

  describe "day" do
    it "is normalized" do
      day =  I18n.t('date.day_names').sample
      stock = create(:stock, day: day)
      stock.save
      expect(stock.day).to eq I18n.t('date.day_names', locale: :en)[I18n.t('date.day_names').index(day)]
    end
  end
end
