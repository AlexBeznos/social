require 'rails_helper'

RSpec.describe ApplicationHelper do

  describe "#localization_links" do
    it "returns links volume" do
      I18n.available_locales.each do |lang|
        expect(helper.localization_links).to include link_to lang, set_locale_path(lang)
      end
    end
  end

end
