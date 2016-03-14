require 'rails_helper'

RSpec.describe Customer do
  it { is_expected.to have_many(:network_profiles).class_name('Customer::NetworkProfile').dependent(:destroy) }
  it { is_expected.to have_many(:visits).class_name('Customer::Visit') }
  it { is_expected.to have_many(:reputations).class_name('Customer::Reputation') }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to belong_to(:social_network) }
  it { is_expected.to accept_nested_attributes_for(:network_profiles) }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to callback(:get_more_customer_info).before(:save).if('first_name =~ /unfinished/') }
  it { is_expected.to callback(:set_gender).before(:save).unless('gender') }

  it "returns a customer's full name as a string" do
    customer = build(:full_name_customer)

    expect(customer.full_name).to eq "#{customer.first_name} #{customer.last_name}"
  end

  it "returns a customer's first name if last name is not set" do
    customer = build(:customer)
    expect(customer.full_name).to eq "#{customer.first_name}"
  end
end
