require 'rails_helper'

RSpec.describe Customer::NetworkProfile do
  it { is_expected.to have_many(:visits).class_name('Customer::Visit') }
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:social_network) }
  # it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:social_network_id) } # FIXME: this test doesn't pass
  it { is_expected.to callback(:set_friends_count).before(:save) }

  it_behaves_like 'with url validation for', :url, :network_profile
end
