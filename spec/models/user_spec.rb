require 'rails_helper'

RSpec.describe User, :type => :model do
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :phone }
  it { is_expected.to ensure_length_of(:phone).is_at_least(10).is_at_most(20) }
  it { is_expected.to belong_to(:franchisee).class_name('User') }
  it { is_expected.to have_many(:places) }
  it { is_expected.to have_many(:place_owners).class_name('User') }

  describe "Phone" do
    it "has valid number" do
      user = build(:user)

      expect(user).to be_valid
    end

    it "has invalid number" do
      user = build(:user, phone: ':3809738338383')
      user.valid?
      expect(user.errors.messages[:phone]).to include("Невірний формат номеру телефона")
    end
  end

  it "returns a user's full name as a string" do
    user = build(:user)

    expect(user.full_name).to eq "#{user.first_name} #{user.last_name}"
  end

  describe "default scope" do
    let!(:user_one) { create(:user, id: 1) }
    let!(:user_two) { create(:user, id: 2) }

    it "orders by ascending id" do
      expect(User.all).to eq([user_one, user_two])
    end
  end
end
