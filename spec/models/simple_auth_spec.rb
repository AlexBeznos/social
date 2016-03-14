require 'rails_helper'

RSpec.describe SimpleAuth do
  it { is_expected.to have_one(:auth) }
end
