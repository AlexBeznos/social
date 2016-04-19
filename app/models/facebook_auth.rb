class FacebookAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:facebook]

  mount_uploader :image, StandartUploader

  has_one :auth, as: :resource

  validates :message, :image, presence: true
  validates :message_url, url: true, allow_blank: true
end
