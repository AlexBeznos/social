require 'rails_helper'

RSpec.describe Stock do
  it { is_expected.to belong_to(:place) }
  it { is_expected.to validate_presence_of :image }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_presence_of :days }
  # it { is_expected.to validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }
  it { is_expected.to callback(:normalize_day).before(:save) }

  it_behaves_like 'with url validation for', :url, :network_profile

  describe "days" do
    it "is normalized" do
      days = ["1", ""]
      stock = create(:stock, days: days)
      stock.save
      expect(stock.days).not_to include ""
    end
  end
end
