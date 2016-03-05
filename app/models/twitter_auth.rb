class TwitterAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:twitter]

  mount_uploader :image, NetworksAuthUploader

  has_one :auth, as: :resource

  validate :twitter_message_length
  validates :message_url, :message, :image, presence: true
  validate :message_url, url: true

  private

  def twitter_message_length
    if (self.message.length + self.message_url.length) >= 140
      errors.add(:message, I18n.t('models.errors.validations.long_twitter_message'))
    end
  end
end
