class MigrateMessages < ActiveRecord::Migration
  include Imagable
  def self.up
    Message.active.each do |message|
      p '_+_+_+_'
      p message.image.url
      unless [41,42, 16].include?(message.id)
        Auth.create!(
          resource_type: "#{message.social_network.name.capitalize}Auth",
          place: message.place,
          redirect_url: message.place.redirect_url,
          resource_attributes: {
            message: message.message,
            message_url: message.message_link,
            remote_image_url: "https:#{message.image.url}"
          }
        )
      end
    end
  end

  def self.down
  end
end
