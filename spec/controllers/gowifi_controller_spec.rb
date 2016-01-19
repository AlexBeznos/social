require "rails_helper"

RSpec.describe GowifiController, :type => :controller do
  let( :place ){ create :place, auth_default_lang: 'en' }

  describe "GET login" do
    it "uses auth_default_lang" do
      get :show, slug: place.slug

      expect(I18n.locale).to eq(place.auth_default_lang.to_sym)

      I18n.locale = I18n.default_locale
    end
  end
end
