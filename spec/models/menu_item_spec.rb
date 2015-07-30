require 'rails_helper'

RSpec.describe MenuItem do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to belong_to(:place) }
  it { should have_and_belong_to_many(:orders) }
  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_size(:image).greater_than(11.kilobytes).less_than(10.megabytes) }
  it { is_expected.to validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }

  describe "Add menu item to order" do
    let(:user) { build(:user) }
    let(:place) { build(:place, user_id: user.id) }
    let(:customer) { build(:customer) }
    let(:order) { place.orders.build(customer_id: customer.id) }
    let(:menu_item) { build(:menu_item) }

    it "success when enough points" do
      reputation = Customer::Reputation.new(place_id: place.id, customer_id: customer.id, score: 1000)

      expect{ menu_item.add_to_order(reputation, order) }.to change{ order.menu_items.size }.by(1)
    end

    it "fail when not enough points" do
      reputation = Customer::Reputation.new(place_id: place.id, customer_id: customer.id, score: 20)

      expect{ menu_item.add_to_order(reputation, order) }.to change{ order.menu_items.size }.by(0)
    end
  end



end
