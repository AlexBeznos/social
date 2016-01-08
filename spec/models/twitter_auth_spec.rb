require 'rails_helper'

RSpec.describe TwitterAuth do
  include_examples 'validates redirect_url'
  include_examples 'standart network setup'

  context 'validates message and message_url length' do
    it 'with invalid params' do
      auth = build(:twitter_auth, message: Faker::Lorem.paragraph)

      expect(auth.valid?).to be_falsey
      expect(auth.errors.messages).to include :message
    end
  end
end
