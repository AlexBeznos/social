require 'open-uri'
class TwitterService
  include Imagable
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @profile = hash[:profile]
  end

  def advertise
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = @profile.access_token
      config.access_token_secret = @profile.access_token_secret
    end

    client.update_with_media(
      "#{@message.message}\n#{@message.message_url}",
      open( to_full_url(@message.image.url) )
    )
  end
end
