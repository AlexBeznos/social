class SocialNetworkIcon < ActiveRecord::Base

  # has_attached_file :icon,
  #                   :storage => :s3,
  #                   :path => "/style/icons/:id/:style.:extension",
  #                   :url => ":s3_domain_url"
  mount_uploader :icon, IconUploader, mount_on: :icon_file_name

  belongs_to :style
  belongs_to :place
  belongs_to :social_network

  validates :place, :style, presence: true
  validates :icon, presence: true # TODO: add proper validations

  before_create :delete_unneeded_icons

  private

  def delete_unneeded_icons
    style.social_network_icons.where(network_name: network_name).delete_all
  end
end
