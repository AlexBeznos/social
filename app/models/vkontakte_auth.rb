class VkontakteAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:vkontakte]

  mount_uploader :image, StandartUploader

  has_one :auth, as: :resource

  with_options if: "posting_enabled?" do |vkauth|
    vkauth.validates :message, :image, :message_url, presence: true
    vkauth.validates :message_url, url: true
  end
end
