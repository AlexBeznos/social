class Message < ActiveRecord::Base
  mount_uploader :image, ImageUploader, mount_on: :image_file_name

  scope :active, -> { where(active: true) }

  belongs_to :social_network
  belongs_to :place

  validates :social_network_id, presence: true
  validates :message, presence: true, unless: 'social_network == 3' # SocialNetwork.find(3).name == 'instagram'
  validates :message_link, :url => true, if: 'message_link && !message_link.empty?'
  validates :subscription, presence: true, if: 'social_network_id == 3'

  validates :image,
            presence: true,
            file_content_type: { allow: ["image/jpeg", "image/png", "image/gif"] },
            file_size: { in: 11.kilobytes..10.megabytes },
                                unless: 'social_network_id == 3'

  validate :twitter_message_length, if: 'social_network_id == 4'

  before_save :set_subscription_uid, if: 'social_network_id == 3'
  after_save :set_active_only_to_one_message_from_place, if: 'active'

  def set_subscription_uid
    self.subscription_uid = InstagramService.get_user_id(self.subscription)
  end

  def set_active_only_to_one_message_from_place
    place = Place.includes(:messages).find(place_id)
    place.messages.where(social_network_id: social_network_id).each do |message|
      message.update(active: false) unless message == self
    end
  end

  def twitter_message_length
    if (message.length + message_link.length) > 141
      errors.add(:message, I18n.t('models.errors.validations.long_twitter_message'))
    end
  end
end
