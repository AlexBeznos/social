require 'open-uri'
class TwitterService
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def advertise
    client = Twitter::REST::Client.new do |config|
      config.customer_key        = ENV['TWITTER_API_KEY']
      config.customer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = @credentials['credentials']['token']
      config.access_token_secret = @credentials['credentials']['secret']
    end

    begin
      client.update_with_media("#{@message.message}\n#{@message.message_link}", open(@message.image.url))
    rescue => e
      Rails.logger.fatal "Twitter message was not posted. Error: #{e}"
    end
  end
end
