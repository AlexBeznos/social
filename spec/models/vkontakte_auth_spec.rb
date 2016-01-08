require 'rails_helper'

RSpec.describe VkontakteAuth do
  include_examples 'validates redirect_url'
  include_examples 'standart network setup'
end
