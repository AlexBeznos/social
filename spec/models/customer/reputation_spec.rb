require 'rails_helper'

RSpec.describe Customer::Reputation do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:place) }
  it { is_expected.to validate_uniqueness_of(:place_id).scoped_to(:customer_id) }

end
