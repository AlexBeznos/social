require 'rails_helper'

RSpec.describe Customer do
  it { is_expected.to have_many(:visits).class_name('Customer::Visit') }
  it { is_expected.to have_many(:reputations).class_name('Customer::Reputation') }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:profiles) }
  it { is_expected.to have_many(:ahoy_visits) }
end
