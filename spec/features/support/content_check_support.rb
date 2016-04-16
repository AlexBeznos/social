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

RSpec.shared_examples "with proper polls" do
  let(:answers){ create_pair(:answer) }
  let(:poll_auth){ create :poll_auth, answers: answers }
  let(:auth){ create :auth, resource: poll_auth }

  it "has proper question" do
    place.auths << auth
    p "*" * 40
    p place.auths.first
    
    visit gowifi_place_path(slug: place.slug)
    click_button I18n.t('wifi.poll')

    expect(page).to have_content(poll_auth.question)
  end

  it "has proper answers" do

  end
end

RSpec.shared_examples "with proper password" do

end
