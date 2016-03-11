require 'rails_helper'

RSpec.describe Banner do
  it { is_expected.to belong_to(:place) }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_attachment_content_type(:content).allowing("image/jpeg", "image/png", "image/gif", "video/mp4", "video/webm") }
end
