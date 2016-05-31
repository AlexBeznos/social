class VkontakteAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:vkontakte]

  mount_uploader :image, StandartUploader

  has_one :auth, as: :resource

  validates :message, :image, :message_url, presence: true
  validates :message_url, url: true

  after_save :clear_attributes, if: "!posting_enabled?"

end
