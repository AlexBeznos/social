class VkService
  include Advertisable
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @credentials = hash[:credentials]
  end

  def advertise
    message = get_message(@place, @credentials['provider'])
    puts @credentials

    vk = VkontakteApi::Client.new(@credentials['credentials']['token'])
    vk.wall.post(owner_id: @credentials['uid'], message: "#{message.message}<br>#{message.image.url}", attachments: message.message_link)

    message.redirect_link
  end
end
