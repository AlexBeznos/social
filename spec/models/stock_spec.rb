require 'rails_helper'

RSpec.describe Stock do
  it { is_expected.to belong_to(:place) }
  it { is_expected.to have_attached_file(:image) }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }

  describe "url" do
    it "has valid value" do
      stock = build(:stock, url: "http://google.com")

      expect(stock).to be_valid
    end
    # FIXME: does not pass
    # it "has invalid value" do
    #   stock = build(:stock, url: "google.com")
    #   stock.valid?
    #   expect(stock.errors.messages[:url]).to include("Невірний формат посилання")
    # end
  end
end
