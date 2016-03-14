require 'rails_helper'

RSpec.describe SocialNetwork do
  it { is_expected.to have_many(:customers) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name) }
end
