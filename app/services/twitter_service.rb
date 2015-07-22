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
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = @credentials['credentials']['token']
      config.access_token_secret = @credentials['credentials']['secret']
    end

    url = @message.image.url
    img = open(url)
    if img.is_a?(StringIO)
      ext = File.extname(url)
      name = File.basename(url, ext)
      Tempfile.new([name, ext])
    else
      img
    end

    begin
      client.update_with_media("#{@message.message}\n#{@message.message_link}", img)
    rescue => e
      Rails.logger.fatal "Twitter message was not posted. Error: #{e}"
    end
  end
end
