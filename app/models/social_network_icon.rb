class SocialNetworkIcon < ActiveRecord::Base

  # has_attached_file :icon,
  #                   :storage => :s3,
  #                   :path => "/style/icons/:id/:style.:extension",
  #                   :url => ":s3_domain_url"
  mount_uploader :icon, IconUploader, mount_on: :icon_file_name

  belongs_to :style
  belongs_to :place
  belongs_to :social_network

  validates :place, :social_network, :style, presence: true
  validates :icon, presence: true # TODO: add proper validations


  before_save :delete_unneeded_icons

  private
    def delete_unneeded_icons
      style.social_network_icons.where(social_network_id: social_network_id).delete_all
    end
end
