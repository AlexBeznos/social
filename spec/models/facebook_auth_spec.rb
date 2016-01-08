require 'rails_helper'

RSpec.describe FacebookAuth do
  include_examples 'validates redirect_url'
  include_examples 'standart network setup'
end
