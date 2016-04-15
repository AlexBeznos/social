RSpec.shared_examples "with social icons" do 
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
