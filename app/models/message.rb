class Message < ActiveRecord::Base
  has_attached_file :image,
                    :storage => :filesystem,
                    :path => "#{Rails.root}/public/messages/:id/:style/:basename.:extension",
                    :url => "/messages/:id/:style/:basename.:extension"

  scope :active, -> { where(active: true) }

  belongs_to :place
  belongs_to :social_network

  # TODO: links validation
  validates :social_network, presence: true
  validates :message, :redirect_link, :message_link, presence: true, unless: 'social_network_id == 3' # SocialNetwork.find(3).name == 'instagram'
  validates :subscription, presence: true, if: 'social_network_id == 3'
  validates_attachment :image, :presence => true,
                                :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] },
                                unless: 'social_network_id == 3'

  before_save :set_subscription_uid, if: 'social_network_id == 3'
  after_save :set_active_only_to_one_message_from_place, if: 'active'

  def set_subscription_uid
    self.subscription_uid = InstagramService.get_user_id(self.subscription)
  end

  def set_active_only_to_one_message_from_place
    self.place.messages.where(social_network: self.social_network).each do |message|
      message.update(active: false) unless message == self
    end
  end
end
