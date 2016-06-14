require "rails_helper"

describe "User authentication by sms", js: true do
  let(:place){ create :place }
  let(:sms_auth){ create :sms_auth }
  let(:auth){ create :auth, resource: sms_auth }

  before(:each) do
    place.auths << auth
    visit gowifi_place_path(slug: place.slug)
  end

  context 'with correct code input' do
    it 'should redirect to auth redirect url' do
      phone = Faker::PhoneNumber.cell_phone

      fill_in('sms_profile[phone]', with: phone)
      within 'form.gowifi_sms_form' do
        find('input[type="submit"]').click
      end

      sms_profile = SmsProfile.find_by(phone: phone)

      expect(current_path).to eq gowifi_sms_confirmation_path(place, sms_profile.id)
      expect(page).not_to have_content(I18n.t('models.errors.validations.wrong_phone_number'))

      fill_in('code', with: sms_profile.code)
      within 'form.by_sms_form' do
        find('input[type="submit"]').click
      end

      expect(current_url).to eq auth.redirect_url
      expect(Customer::Visit.count).to eq 1
      expect(Customer::Visit.last.account_type).to eq "SmsProfile"
    end
  end

  context 'with incorect' do
    it 'phone number should be raised alert' do
      phone = 'fake phone'

      fill_in('sms_profile[phone]', with: phone)
      within 'form.gowifi_sms_form' do
        find('input[type="submit"]').click
      end

      expect(current_path).to eq gowifi_place_path(slug: place.slug)
      expect(page).to have_content(I18n.t('models.errors.validations.wrong_phone_number'))
      expect(Customer::Visit.count).to be_zero
    end

    it 'code should be raised alert' do
      phone = Faker::PhoneNumber.cell_phone

      fill_in('sms_profile[phone]', with: phone)
      within 'form.gowifi_sms_form' do
        find('input[type="submit"]').click
      end

      fill_in('code', with: '1234')
      within 'form.by_sms_form' do
        find('input[type="submit"]').click
      end

      expect(page.has_css?('.alert', text: I18n.t('wifi.sms_try_more'))).to eq true
      expect(Customer::Visit.count).to be_zero
    end
  end
end
