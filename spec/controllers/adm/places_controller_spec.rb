require 'rails_helper'
require 'adm/places_controller'

RSpec.describe Adm::PlacesController do
  describe "Test all_messages" do      
    it "should return both Place group's and Place's messages" do
      user = create(:user, :user_general)
      place_group = create(:place_group, user: user)
      place = create(:place, user: user, place_group: place_group)
      message = create(:message, with_message: place, active: true)
      message = create(:message, with_message: place_group, active: false)
      social_network = create(:social_network, name: "facebook", id: 2)
      controller.instance_variable_set(:@place, place)
      expect(controller.send(:all_messages).count).to eq 2
    end
  end
end
