require 'rails_helper'

RSpec.describe PollAuth do
  it { is_expected.to have_one(:auth) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to validate_presence_of :question }
  it { is_expected.to accept_nested_attributes_for(:answers).allow_destroy(true) }
end
