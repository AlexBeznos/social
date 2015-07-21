require 'rails_helper'

RSpec.describe Stock, :type => :model do
  it { should belong_to(:place) }
  it { should have_attached_file(:image) }
  it { should validate_presence_of :place_id }
  it { should validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }

  describe "url" do
    it "has valid value" do
      stock = build(:stock, url: "http://google.com")

      expect(stock).to be_valid
    end

    it "has invalid value" do
      stock = build(:stock, url: "google.com")
      stock.valid?
      expect(stock.errors.messages[:url]).to include("Невірний формат посилання")
    end
  end
end
