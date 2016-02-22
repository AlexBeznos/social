require 'rails_helper'
# require 'carrierwave/test/matchers'

RSpec.describe MenuItem do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to belong_to(:place) }
  it { should have_and_belong_to_many(:orders) }
  # it { should have_attached_file(:image) }
  # it { should validate_attachment_presence(:image) }
  # it { should validate_attachment_size(:image).greater_than(11.kilobytes).less_than(10.megabytes) }
  # it { is_expected.to validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }

  # it 'asdasd' do
  #   menu_item = MenuItem.new
  #   menu_item.image =
  #   menu_item.valid?
  #
  #   expect(menu_item.errors.messages).to include('not proper value')

  # end
end
