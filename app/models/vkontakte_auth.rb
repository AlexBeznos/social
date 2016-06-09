class VkontakteAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:vkontakte]

  mount_uploader :image, StandartUploader

  has_one :auth, as: :resource

  with_options if: "posting_enabled?" do |vkauth|
    vkauth.validates :message, :image, presence: true
  end
  
  validates :message_url, url: true, allow_blank: true
end
