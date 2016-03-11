require 'rails_helper'

RSpec.describe MenuItem do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_presence_of :image }
  it { is_expected.to belong_to(:place) }
  it { should have_and_belong_to_many(:orders) }
  it { is_expected.to validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }
end
