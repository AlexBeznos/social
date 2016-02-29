class VkAuth < ActiveRecord::Base
  NAME = 'vk'

  mount_uploader :image, NetworksAuthUploader

  has_one :auth, as: :resource

  validates :message_url, :message, :image, presence: true
  validates :message_url, url: true
end
