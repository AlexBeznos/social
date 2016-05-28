require 'rails_helper'

describe "Auth form", js: true do
  let(:user){ create :user_franchisee }
  let(:place){ create :place, user: user }
  let(:fb){ create :facebook_auth }
  let(:auth){ create :auth, place: place, resource: fb }

  before(:each) do
    login(user)
  end

  context "On create" do
    it "hides form when posting_enabled: false" do
      visit new_place_auth(place)


    end

    it "show form when posting_enabled: true" do

    end
  end

  context "On update" do
    it "hides form when posting_enabled: false" do

    end

    it "show form when posting_enabled: true" do

    end
  end
end
