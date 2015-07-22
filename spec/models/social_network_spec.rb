require 'rails_helper'

RSpec.describe SocialNetwork, :type => :model do
  it { is_expected.to have_many(:messages) }
  # it { is_expected.to have_many(:customers) } #TODO: there is no foreign key at Customer model
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe "Font awesome name" do
    it "returns vk" do
      social_network = SocialNetwork.new(name: 'vkontakte')

      expect(social_network.font_awesome_name).to eq('vk')
    end

    it "returns another social network name" do
      social_network = SocialNetwork.new(name: 'twitter')

      expect(social_network.font_awesome_name).to eq('twitter')
    end
  end
end
