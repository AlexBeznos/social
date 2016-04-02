require 'rails_helper'

RSpec.describe MenuItem do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_presence_of :image }
  it { is_expected.to belong_to(:place) }
  it { should have_and_belong_to_many(:orders) }

  describe "#disable_place_scratchcard" do
    let(:place){ create :place }
    let(:menu_item){ create :menu_item, place: place }

    context "when no menu items" do
      it "disables scratchcard in proper place" do
        place.update(scratchcard: true)
        menu_item.destroy
        expect(place.scratchcard).to be(false)
      end
    end
  end
end
