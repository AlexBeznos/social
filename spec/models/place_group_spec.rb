require 'rails_helper'

RSpec.describe PlaceGroup, :type => :model do
  subject { FactoryGirl.build(:place_group, user: create(:user, :user_general)) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:messages) }
  it { is_expected.to have_many(:places) }
  it { is_expected.to validate_presence_of :name }


  describe "Validate user group" do
    it "must be 'general'" do
      user = create(:user, :user_franchisee)
      place_group = build(:place_group, user: user)
      expect(place_group).to_not be_valid
    end
  end
end
