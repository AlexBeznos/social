class Message < ActiveRecord::Base
  has_attached_file :image,
                    :storage => :s3,
                    :path => "/images/:id/:style.:extension",
                    :url => ":s3_domain_url"

  belongs_to :place

  enum network: [ :vk,
                  :facebook,
                  :twitter,
                  :instagram ]

  validates :network, presence: true
  validates :message, :redirect_link, :message_link, presence: true, unless: 'network.to_sym == :instagram'
  validates :subscription, presence: true, if: 'network.to_sym == :instagram'
  validates_attachment :image, :presence => true,
                                :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] },
                                unless: 'network.to_sym == :instagram'

  before_save :set_subscription_uid, if: 'network.to_sym == :instagram'
  after_save :set_active, if: 'active'

  def set_active
    self.place.messages.where(network: self.network).each do |message|
      message.update(active: false) unless message == self
    end
  end

  def set_subscription_uid
    self.subscription_uid = Instagram.user_search(self.subscription, :count => 1).first['id']
  end
end
