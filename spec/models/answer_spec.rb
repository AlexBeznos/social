require 'rails_helper'

RSpec.describe Answer do
  it { is_expected.to belong_to(:poll_auth) }
end
