require "rails_helper"

describe "User clicks network link" do
  let(:place){ create :place }
  let(:vk){ create :vkontakte_auth }
  let(:auth){ create :auth, resource: vk }

  before(:each) do
    place.auths << auth
    auth.approve!
    set_omniauth()
    visit gowifi_place_path(slug: place.slug)
  end

  context "when posting enabled" do
    it "should create advertising worker" do
      vk.update( posting_enabled: true)
      find("a.wifi_link").click
      expect(AdvertisingWorker.jobs.size).to eq(1)
    end
  end

  context "when posting disabled" do
    it "shouldn`t create advertising worker" do
      vk.update( posting_enabled: false)
      find("a.wifi_link").click
      expect(AdvertisingWorker.jobs.size).to eq(0)
    end
  end
end
