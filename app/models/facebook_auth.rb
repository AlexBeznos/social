class FacebookAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:facebook]

  mount_uploader :image, NetworksAuthUploader

  has_one :auth, as: :resource

  validates :message, :image, presence: true
  validates :message_url, url: true, unless: 'message_url.blank?'
end
