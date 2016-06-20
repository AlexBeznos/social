require "rails_helper"

describe "User authentication by sms", js: true do
  let(:place){ create :place }
  let(:password_auth){ create :password_auth }
  let(:auth){ create :auth, resource: password_auth }

  before(:each) do
    place.auths << auth
    visit gowifi_place_path(slug: place.slug)
  end

  it 'should redirect to auth url when password correct' do
    within 'form.password_form' do
      fill_in('password', with: password_auth.password)
      find('input[type="submit"]').click
    end

    expect(current_url).to eq auth.redirect_url
    expect(Customer::Visit.count).to eq 1
    expect(Customer::Visit.last.account_type).to eq "PasswordProfile"
  end

  it 'should redirect back when password incorect' do
    within 'form.password_form' do
      fill_in('password', with: 'fake_password')
      find('input[type="submit"]').click
    end

    expect(current_path).to eq gowifi_place_path(slug: place.slug)
    expect(Customer::Visit.count).to be_zero
  end
end
