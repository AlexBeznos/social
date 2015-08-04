require 'rails_helper'

RSpec.describe Style do
  it { is_expected.to have_many(:social_network_icons) }
  it { is_expected.to belong_to(:place) }
  it { is_expected.to accept_nested_attributes_for(:social_network_icons) }
  it { is_expected.to have_attached_file(:background) }
  it { is_expected.to validate_attachment_content_type(:background).allowing("image/jpeg", "image/png", "image/gif") }
  it { is_expected.to callback(:precompile_css).before(:save).if('css') }
  it { is_expected.to callback(:precompile_js).before(:save).if('js') }


  describe "Css colours" do
    it "have valid values" do
      style = build(:style)

      expect(style).to be_valid
    end

    context "text color" do
      it "has invalid value" do
        style = build(:style, text_color: "shit")
        style.valid?
        expect(style.errors.messages[:text_color]).to include(I18n.t('models.errors.validations.not_valid_css_color'))
      end
    end

    context "greating color" do
      it "has invalid value" do
        style = build(:style, greating_color: "shit")
        style.valid?
        expect(style.errors.messages[:greating_color]).to include(I18n.t('models.errors.validations.not_valid_css_color'))
      end
    end
  end
end
