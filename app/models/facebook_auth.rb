class FacebookAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:facebook]

  mount_uploader :image, StandartUploader

  has_one :auth, as: :resource

  with_options if: "posting_enabled?" do |fsauth|
    fsauth.validates :message, :image, :message_url, presence: true
    fsauth.validates :message_url, url: true
  end
end
