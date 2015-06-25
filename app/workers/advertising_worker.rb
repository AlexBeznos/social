class AdvertisingWorker
  include Sidekiq::Worker
  include Consumerable

  sidekiq_options :queue => :advertisment, :retry => false

  def perform(place_slug, credentials)
    @place = Place.find_by_slug(place_slug)
    @credentials = credentials

    post_advertisment
  end

  private
    def post_advertisment
      message = get_message(@place, @credentials['provider'])
      attrs = {:place => @place, :message => message, :credentials => @credentials}

      case @credentials['provider']
      when 'twitter'
         TwitterService.new(attrs).advertise
      when 'instagram'
         InstagramService.new(attrs).advertise
      when 'vkontakte'
         VkService.new(attrs).advertise
      when 'facebook'
         FacebookService.new(attrs).advertise
      end
    end

end
