require 'rails_helper'

describe "Place login page" do
  context "When place is not provided" do
    let(:place){ build :place }

    it "redirects to 404" do
      allow(place).to receive(:slug) { "lol" }

      visit gowifi_place_path(slug: place.slug)

      expect(current_path).to eq("/404.html")
    end

  end
end
