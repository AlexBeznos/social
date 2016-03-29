class MigrateSocialNetworkIcons < ActiveRecord::Migration
  def self.up
    SocialNetworkIcon.includes(:social_network).each do |icon|
      icon.update!(network_name: icon.social_network.name)
    end
  end

  def self.down
  end
end
