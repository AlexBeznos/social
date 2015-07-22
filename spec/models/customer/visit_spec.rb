require 'rails_helper'

RSpec.describe Customer::Visit, :type => :model do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:place) }
  it { is_expected.to belong_to(:network_profile).class_name('Customer::NetworkProfile') }
end
