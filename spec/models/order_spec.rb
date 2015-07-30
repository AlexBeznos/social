require 'rails_helper'

RSpec.describe Order do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:place) }
  it { should have_and_belong_to_many(:menu_items) }
end