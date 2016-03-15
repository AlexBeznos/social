class TwitterAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:twitter]

  mount_uploader :image, NetworksAuthUploader

  has_one :auth, as: :resource

  # validate :twitter_message_length
  validates :message, :image, presence: true
  validates :message_url, url: true, if: 'message_url && !message_url.blank?'


  private

  def twitter_message_length
    return if message.blank? || message_url.blank?

    if (message.length + message_url.length) > 140
      errors.add(:message, I18n.t('models.errors.validations.long_twitter_message'))
    end
  end
end
