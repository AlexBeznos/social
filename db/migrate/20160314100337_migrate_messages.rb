class MigrateMessages < ActiveRecord::Migration
  def self.up
    Message.active.each do |message|
      Auth.create(
        resource_type: "#{message.social_network.name.capitalize}Auth",
        place_id: message.place_id,
        redirect_url: message.place.redirect_url,
        resource_attributes: {
          message: message.message,
          message_url: message.message_link,
          remote_image_url: message.image.url
        }
      )
    end
  end

  def self.down
  end
end
