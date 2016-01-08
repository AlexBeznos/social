class TwitterAuth < GeneralAuth
  include StandartNetworkSetup

  validate :twitter_message_length, if: "message && message_url"

  private
  def twitter_message_length
    if (message.length + message_url.length) > 141
      errors.add(:message, I18n.t('models.errors.validations.long_twitter_message'))
    end
  end
end
