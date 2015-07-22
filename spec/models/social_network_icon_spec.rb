require 'rails_helper'

RSpec.describe SocialNetworkIcon do
  it { is_expected.to have_attached_file(:icon) }
  it { is_expected.to belong_to(:style) }
  it { is_expected.to belong_to(:place) }
  it { is_expected.to belong_to(:social_network) }
  it { is_expected.to validate_presence_of :place }
  it { is_expected.to validate_presence_of :social_network }
  it { is_expected.to validate_presence_of :style }
  it { is_expected.to validate_attachment_content_type(:icon).allowing("image/jpeg", "image/png", "image/gif") }
  it { is_expected.to callback(:delete_unneeded_icons).before(:save) }
end
