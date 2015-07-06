class Message < ActiveRecord::Base
  has_attached_file :image,
                    :storage => :s3,
                    :path => "/images/:id/:style.:extension",
                    :url => ":s3_domain_url"

  scope :active, -> { where(active: true) }

  belongs_to :place
  belongs_to :social_network

  # TODO: links validation
  validates :social_network, presence: true
  validates :message, presence: true, unless: 'social_network_id == 3' # SocialNetwork.find(3).name == 'instagram'
  validates :subscription, presence: true, if: 'social_network_id == 3'
  validates_attachment :image, :presence => true,
                                :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] },
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
      errors.add(:message, I18n.t('errors.long_twitter_message'))
    end
  end
end
