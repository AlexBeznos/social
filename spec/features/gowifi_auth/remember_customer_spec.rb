require 'rails_helper'

describe "visit login page with enabled remembering" do
  let(:place){create :place, mfa: true, remember_device: true}
  let(:sms_res){ create :sms_auth }
  let(:sec_res){ create :simple_auth }
  let(:sms_auth){ create :auth, resource: sms_res, step: "primary"  }
  let(:second_step_auth){ create :auth, resource: sec_res, step: "secondary" }

  before(:each) do
    place.auths << sms_auth
    place.auths << second_step_auth

    visit gowifi_place_path(slug: place.slug, mac: "some_mac")

    phone = "093-881-4202"

    fill_in('sms_profile[phone]', with: phone)
    within 'form.gowifi_sms_form' do
      find('input[type="submit"]').click
    end

    sms_profile = SmsProfile.find_by(phone: phone)

    fill_in('code', with: sms_profile.code)
    within 'form.by_sms_form' do
      find('input[type="submit"]').click
    end
  end

  describe "when sms auth first time" do
    it "creates proper device" do
      expect(Device.last.mac_address).to eq("some_mac")
    end

    it "sets expiration date to device" do
      expiration_date = (Time.zone.now  + 90.days).to_formatted_s(:rfc822)
      device_expires_at = Device.last.remembering_expires_at.to_formatted_s(:rfc822)

      expect(device_expires_at).to be === (expiration_date)
    end
  end

  describe "when visit login page another time" do
    before(:each) do
      click_link(I18n.t('wifi.simple_enter'))

      visit gowifi_place_path(slug: place.slug, mac: "some_mac")
    end

    context "when device still remember" do
      it "shows second auth step" do
        expect(page).to have_content(I18n.t('wifi.simple_enter'))
      end
    end
  end
end
