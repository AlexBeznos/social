require 'rails_helper'

RSpec.describe PlacesController do
  

  describe "Test active_message" do      
    it "return Place's message if Place is in Place group, but Place group's message for the same social network is inactive" do
      user = create(:user, :user_general)
      place_group = create(:place_group, user: user)
      place = create(:place, user: user, place_group: place_group)
      message = create(:message, with_message: place, active: true)
      message = create(:message, with_message: place_group, active: false)
      social_network = create(:social_network, name: "facebook", id: 2)
      controller.instance_variable_set(:@place, place)
      expect(controller.send(:active_message, "facebook").with_message_type).to eq "Place"
    end
  end
end
