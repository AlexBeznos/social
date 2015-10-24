require 'rails_helper'

RSpec.describe Poll do
  it { is_expected.to belong_to(:place) }
  it { is_expected.to have_many(:answers) }
  it { is_expected.to validate_presence_of :place_id }
  it { is_expected.to validate_presence_of :question }
  
  describe 'Accept nested attributes' do
    it "creates nested answer" do
      poll = create(:poll)
      poll.answers.build(attributes_for(:answer))
      expect { poll.save }.to change(Answer, :count).by(1)
    end
  end
end
