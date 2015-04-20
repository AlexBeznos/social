class Message < ActiveRecord::Base
  serialize :attachments, Array
  belongs_to :place
  enum type: [:vk, :facebook, :twitter]

  validates :message, :type, presence: true

  after_save :set_active

  def set_active
    if self.active
      self.place.messages.where(type: self.type).each do |message|
        message.update(active: false) unless message == self
      end
    end
  end
end
