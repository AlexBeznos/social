require 'rails_helper'

describe "Ahoy visits" do
  let(:place) { create :place }
  let(:vkontakte_auth) { create :vkontakte_auth }
  let(:auth) { create :auth, place: place, resource: vkontakte_auth }
  let(:sms) { create :gowifi_sms }

  it "creates new visit" do
    visitable_pages = [
      gowifi_place_path(place),
      preview_path(place, auth_id: auth.id),
      gowifi_sms_confirmation_path(place, sms)
    ]

    visitable_pages.each do |page|
      AhoyVisit.destroy_all
      expect {visit page}.to change{AhoyVisit.count}.by(1)
    end
  end
end
