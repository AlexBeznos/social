require 'rails_helper'

RSpec.describe Order do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:place) }
  it { should have_and_belong_to_many(:menu_items) }

  describe "Add menu item to order" do
    let(:user) { build(:user) }
    let(:place) { create(:place, user_id: user.id) }
    let(:customer) { create(:customer) }
    let(:order) { build(:order, place: place, customer: customer) }
    let(:menu_item) { build(:menu_item) }

    it "success when enough points" do
      reputation = Customer::Reputation.new(place_id: place.id, customer_id: customer.id, score: 1000)

      expect{ order.add_menu_item(reputation, menu_item) }.to change{ order.menu_items.size }.by(1)
    end

    it "fail when not enough points" do
      reputation = Customer::Reputation.new(place_id: place.id, customer_id: customer.id, score: 20)

      expect{ order.add_menu_item(reputation, menu_item) }.to change{ order.menu_items.size }.by(0)
    end

    it "sets price when adds menu item" do
      reputation = Customer::Reputation.new(place_id: place.id, customer_id: customer.id, score: 1000)

      order.add_menu_item(reputation, menu_item)
      order.add_menu_item(reputation, menu_item)

      price = menu_item.price * 2
  
      expect(order.price).to eq(price)
    end
  end
end
