class SocialNetworkIcon < ActiveRecord::Base

  has_attached_file :icon,
                    :storage => :s3,
                    :path => "/style/icons/:id/:style.:extension",
                    :url => ":s3_domain_url"

  belongs_to :style
  belongs_to :place
  belongs_to :social_network

  validates :place, :social_network, :style, presence: true
  validates_attachment :icon,
                       :presence => true,
                       :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }

  before_save :delete_unneeded_icons

  private
    def delete_unneeded_icons
      style.social_network_icons.where(social_network_id: social_network_id).delete_all
    end
end