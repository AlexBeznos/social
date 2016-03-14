class MigrateMessages < ActiveRecord::Migration
  include Imagable
  def self.up
    Message.active.each do |message|
      p '_+_+_+_'
      p message.image.url
      Auth.create!(
        resource_type: "#{message.social_network.name.capitalize}Auth",
        place: message.place,
        redirect_url: message.place.redirect_url,
        resource_attributes: {
          message: message.message,
          message_url: message.message_link,
          remote_image_url: to_full_url(message.image.url)
        }
      )
    end
  end

  def self.down
  end
end
