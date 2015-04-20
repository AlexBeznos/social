class Message < ActiveRecord::Base
  has_attached_file :image,
                    :storage => :s3,
                    :path => "/images/:id/:style.:extension",
                    :url => ":s3_domain_url"

  belongs_to :place

  enum network: [:vk, :facebook, :twitter]

  validates :message, :network, :redirect_link, :message_link, presence: true
  validates_attachment :image, :presence => true,
                                :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }

  after_save :set_active, if: 'active'

  def set_active
    self.place.messages.where(network: self.network).each do |message|
      message.update(active: false) unless message == self
    end
  end
end
