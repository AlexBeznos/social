class SocialNetworkIcon < ActiveRecord::Base
  mount_uploader :icon, IconUploader, mount_on: :icon_file_name

  belongs_to :style
  belongs_to :place

  validates :place, :style, :icon, presence: true

  before_create :delete_unneeded_icons

  private

  def delete_unneeded_icons
    style.social_network_icons.where(network_name: network_name).delete_all
  end
end
