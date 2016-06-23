require "rails_helper"

['vkontakte', 'twitter', 'facebook', 'instagram'].each do |network|
  describe "User on gowifi show page" do
    let(:place){ create :place }
    let(:network_auth){ create("#{network}_auth".to_sym) }
    let(:auth){ create :auth, resource: network_auth }

    before(:each) do
      place.auths << auth
      auth.approve!
    end

    context "in case of icon presence in styles" do
      let!(:style) do
        img = File.new(Rails.root.join('spec', 'fixtures', 'image.jpg'))
        create :style, "#{network}_icon" => img, "place" => place
      end

      before { visit gowifi_place_path(slug: place.slug) }

      it "should see icon from styles" do
        image_url = style.send("#{network}_icon").url
        expect(page.find(".socials .wifi_link img")["src"]).to eq image_url
      end
    end

    context "in case of icon absence in styles" do
      before { visit gowifi_place_path(slug: place.slug) }

      it "should see default icon" do
        image_url = "/assets/wifi/#{auth.name}.png"
        expect(page.find(".socials .wifi_link img")["src"]).to eq image_url
      end
    end

  end
end
