require 'open-uri'
class TwitterService
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @credentials = hash[:credentials]
  end

  def send_message
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = @credentials['credentials']['token']
      config.access_token_secret = @credentials['credentials']['secret']
    end

    message = self.get_message
    begin
      client.update_with_media("#{message.message}\n#{message.message_link}", open(message.image.url))
    rescue => e
      Rails.logger.fatal "Twitter message was not posted. Error: #{e}"
    end
    message.redirect_link
  end

  def get_message
    @place.messages.where(network: Message.networks[:twitter]).first
  end
end
