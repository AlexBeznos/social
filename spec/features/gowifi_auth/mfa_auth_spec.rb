require "rails_helper"

describe "User authentication by password with enabled mfa", js: true do
  let(:place){ create :place, mfa: true }
  let(:password_auth_1){ create :password_auth }
  let(:password_auth_2){ create :password_auth }
  let(:redirect_url_2){ 'https://ya.ru/' }
  let(:auth_1){ create :auth, resource: password_auth_1, step: 'primary' }
  let(:auth_2){ create :auth, resource: password_auth_2, redirect_url: redirect_url_2, step: 'secondary' }

  before(:each) do
    place.auths << auth_1
    place.auths << auth_2
    visit gowifi_place_path(slug: place.slug)
  end

  it 'should redirect to auth_2 url when both passwords correct' do
    within 'form.password_form' do
      fill_in('password', with: password_auth_1.password)
      find('input[type="submit"]').click
    end

    expect(current_path).to eq gowifi_place_path(slug: place.slug)
    expect(Customer::Visit.count).to eq 1
    expect(Customer::Visit.last.account_type).to eq "PasswordProfile"

    within 'form.password_form' do
      fill_in('password', with: password_auth_2.password)
      find('input[type="submit"]').click
    end


    expect(current_url).to eq auth_2.redirect_url
    expect(Customer::Visit.count).to eq 2
    expect(Customer::Visit.last.account_type).to eq "PasswordProfile"
  end

  it 'should redirect back when password incorect on second step' do
    within 'form.password_form' do
      fill_in('password', with: password_auth_1.password)
      find('input[type="submit"]').click
    end

    expect(current_path).to eq gowifi_place_path(slug: place.slug)
    expect(Customer::Visit.count).to eq 1
    expect(Customer::Visit.last.account_type).to eq "PasswordProfile"

    within 'form.password_form' do
      fill_in('password', with: '123123123123')
      find('input[type="submit"]').click
    end

    expect(current_path).to eq gowifi_place_path(slug: place.slug)
    expect(Customer::Visit.count).to eq 1
  end
end
