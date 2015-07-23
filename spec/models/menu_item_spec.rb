require 'rails_helper'

RSpec.describe MenuItem, :type => :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to belong_to(:place) }


end
