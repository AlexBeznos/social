class AdvertisingWorker
  include Sidekiq::Worker
  include Consumerable

  sidekiq_options :queue => :advertisment, :retry => false

  def perform(place_slug, credentials, edited_message = nil)
    @place = Place.find_by_slug(place_slug)
    @credentials = credentials
    @edited_message = edited_message

    post_advertisment
  end

  private
    def post_advertisment
      @message = get_message(@place, @credentials['provider'])

      if @credentials['provider'] == 'facebook'
        attrs = {:place => @place, :message => @edited_message, :credentials => @credentials}
      else
        # Here we convert @message to @edited_message and pass to the second one original attributes from @message
        update_original_message_attribute
        attrs = {:place => @place, :message => @edited_message, :credentials => @credentials}
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

    def update_original_message_attribute
      @edited_message.update_attributes(message: @message.message,
                                        message_link: @message.message_link,
                                        image_file_name: @message.image.url)
    end

end
