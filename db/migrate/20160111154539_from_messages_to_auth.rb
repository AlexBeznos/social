class FromMessagesToAuth < ActiveRecord::Migration
  def self.up
    GeneralAuth::NETWORKS.each do |network|
      p network.capitalize
      klass = "#{network.capitalize}Auth".constantize
      messages = Message.joins(:social_network)
                        .where(social_networks: { name: network })

      messages.each do |message|
        p message.id
        n = klass.new
        n.message = message.message
        n.message_url = message.message_link
        n.place_id = message.with_message_id
        n.redirect_url = message.with_message.redirect_url
        n.remote_image_url = message.image.url
        n.save
      end unless klass.any?
    end
  end

  def self.down
  end
end
