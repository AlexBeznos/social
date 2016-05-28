require 'rails_helper'

describe "Auth form", js: true do
  let(:user){ create :user_franchisee }
  let(:place){ create :place, user: user }
  let(:fb){ create :facebook_auth }
  let(:auth){ create :auth, place: place, resource: fb }

  before(:each) do
    login(user)
    I18n.locale = :en
  end

  context "On create" do
    let(:auth_method_form_selectors) do
      [
        "label[for='auth_method_image']",
        "input#auth_method_image",
        "label[for='auth_method_message']",
        "textarea#auth_method_message",
        "label[for='auth_method_message_url']",
        "input#auth_method_message_url"
      ].join(",")
    end

    before(:each) do
      visit new_place_auth_path(place)
      find(".authMethodSelect").select(I18n.t("models.auths.methods.facebook"))
    end

    it "hides form when posting_enabled: false" do
      expect(page).to_not have_selector(auth_method_form_selectors)
    end

    it "show form when posting_enabled: true" do
      find("#auth_method_posting_enabled").click
      expect(page).to have_selector(auth_method_form_selectors)
    end
  end

  context "On update" do
    let(:auth_resource_attributes_form_selectors) do
      [
        "label[for='auth_resource_attributes_image']",
        "input#auth_resource_attributes_image",
        "label[for='auth_resource_attributes_message']",
        "textarea#auth_resource_attributes_message",
        "label[for='auth_resource_attributes_message_url']",
        "input#auth_resource_attributes_message_url"
      ].join(",")
    end

    it "hides form when posting_enabled: false" do
      fb.update(posting_enabled:  false)
      visit edit_place_auth_path(place_id: place.slug, id: auth.id)

      expect(page).to_not have_selector(auth_resource_attributes_form_selectors)
    end

    it "show form when posting_enabled: true" do
      visit edit_place_auth_path(place_id: place.slug, id: auth.id)

      expect(page).to have_selector(auth_resource_attributes_form_selectors)
    end
  end
end
