module StandartNetworkSetup
  extend ActiveSupport::Concern

  included do
    validates :message, :message_url, :image, presence: true
    mount_uploader :image, PostImageUploader
  end
end
