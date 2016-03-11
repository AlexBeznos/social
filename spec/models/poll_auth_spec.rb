require 'rails_helper'

RSpec.describe PollAuth do
  it { is_expected.to have_one(:auth) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to validate_presence_of :question }
  it { is_expected.to accept_nested_attributes_for(:answers).allow_destroy(true) }

  # describe 'Accept nested attributes' do
  #   it "creates nested answer" do
  #     poll = create(:poll)
  #     poll.answers.build(attributes_for(:answer))
  #     expect { poll.save }.to change(Answer, :count).by(1)
  #   end
  # end
end
