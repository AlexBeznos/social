require "rails_helper"

describe "User authentication by simple enter" do
  let(:place){ create :place }
  let(:simple_auth){ create :simple_auth }
  let(:auth){ create :auth, resource: simple_auth }

  before(:each) do
    place.auths << auth
    visit gowifi_place_path(slug: place.slug)
  end

  it "should redirect to url from auth" do
    click_link(I18n.t('wifi.simple_enter'))

    expect(current_url).to eq(auth.redirect_url)
  end
end
