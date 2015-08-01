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
      attrs = { place: @place, message: message, credentials: @credentials }

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

    ##
    # Why do u use update_attributes if it is the same as update? update_attributes - old fashioned style of current 'update' method
    #def update_original_message_attribute
    #  @edited_message.update_attributes(message: @message.message,
    #                                    message_link: @message.message_link,
    #                                    image_file_name: @message.image.url)
    #end

end
