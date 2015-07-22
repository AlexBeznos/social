require 'rails_helper'

RSpec.describe Style, :type => :model do
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
        expect(style.errors.messages[:text_color]).to include("не справжній css колір")
      end
    end

    context "greating color" do
      it "has invalid value" do
        style = build(:style, greating_color: "shit")
        style.valid?
        expect(style.errors.messages[:greating_color]).to include("не справжній css колір")
      end
    end
  end
end
