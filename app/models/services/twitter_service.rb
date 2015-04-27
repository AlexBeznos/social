require 'open-uri'
class TwitterService
  include Advertisable

  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @credentials = hash[:credentials]
  end

  def advertise
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = @credentials['credentials']['token']
      config.access_token_secret = @credentials['credentials']['secret']
    end

    message = get_message(@place, @credentials['provider'])
    
    begin
      client.update_with_media("#{message.message}\n#{message.message_link}", open(message.image.url))
    rescue => e
      Rails.logger.fatal "Twitter message was not posted. Error: #{e}"
    end

    create_consumer('twitter', @credentials)
    message.redirect_link
  end
end
