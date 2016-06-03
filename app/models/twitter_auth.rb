class TwitterAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:twitter]

  mount_uploader :image, StandartUploader

  has_one :auth, as: :resource

  with_options if: "posting_enabled?" do
    validates :message, :image, :message_url, presence: true
    validate :twitter_message_length
  end

  validates :message_url, url: true, allow_blank: true

  def twitter_message_length
    return if message.blank? || message_url.blank?

    if (message.length + message_url.length) > 140
      errors.add(:message, I18n.t('models.errors.validations.long_twitter_message'))
    end
  end
end
