require 'rails_helper'

RSpec.describe SocialNetworkIcon do
  it { is_expected.to belong_to(:style) }
  it { is_expected.to belong_to(:place) }
  it { is_expected.to validate_presence_of :place }
  it { is_expected.to validate_presence_of :style }
  it { is_expected.to validate_presence_of :icon }
  it { is_expected.to callback(:delete_unneeded_icons).before(:create) }
end
