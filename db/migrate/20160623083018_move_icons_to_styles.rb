class MoveIconsToStyles < ActiveRecord::Migration
  include Imagable
  def self.up
    networks = Auth::NETWORKS.values
    Style.find_each do |style|
      SocialNetworkIcon.where(style: style, network_name: networks).each do |network_icon|
        style.send("remote_#{network_icon.network_name}_icon_url=", to_full_url(network_icon.icon.url))
        style.save!
      end
    end
  end

  def self.down
  end
end
