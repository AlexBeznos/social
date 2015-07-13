require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :phone }
  it { should ensure_length_of(:phone).is_at_least(10).is_at_most(20) }
  it { should belong_to(:franchisee).class_name('User') }

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
end
