require "rails_helper"

describe "Place wifi login page" do
  let(:place){
    create :place
  }

  context "Social auths " do

    Auth::NETWORKS.values.each do |net|
      it "Proper #{net} icon exists" do
        resource = net + "_auth"
        network_icon = "img.#{net}_icon"

        place.auths << create(:auth, resource: create(resource))
        place.auths.first.approve!

        visit gowifi_place_path(slug: place.slug)

        expect(page).to have_selector(network_icon)
      end
    end
  end

  context "Poll auth" do
    it "ddd" do
    end
  end

  context "Password auth" do

  end
end
