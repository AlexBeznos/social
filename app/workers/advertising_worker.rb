class AdvertisingWorker
  include Sidekiq::Worker
  include Consumerable

  sidekiq_options :queue => :advertisment, :retry => false

  def perform(place_slug, credentials, client_ip = nil)
    @place = Place.find_by_slug(place_slug)
    @credentials = credentials
    @edited_message = JSON.parse(ReadCache.redis.get(client_ip)) if @credentials['provider'] == 'facebook'

    post_advertisment
  end

  private
    def post_advertisment
      message = get_message(@place, @credentials['provider'])

      if @credentials['provider'] == 'facebook'
        attrs = { place: @place, message: @edited_message, credentials: @credentials, hash: true }
      else
        attrs = { place: @place, message: message, credentials: @credentials }
      end

      case @credentials['provider']
      when 'twitter'
         TwitterService.new(attrs).advertise
      when 'instagram'
         InstagramService.new(attrs).advertise
      when 'vkontakte'
         VkService.new(attrs).advertise
      when 'facebook'
         FacebookService.advertise(attrs)
      end
    end

end
