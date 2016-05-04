require 'rails_helper'

RSpec.describe Customer do
  it { is_expected.to have_many(:network_profiles).class_name('Customer::NetworkProfile').dependent(:destroy) }
  it { is_expected.to have_many(:visits).class_name('Customer::Visit') }
  it { is_expected.to have_many(:reputations).class_name('Customer::Reputation') }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to belong_to(:social_network) }
  it { is_expected.to accept_nested_attributes_for(:network_profiles) }
end
