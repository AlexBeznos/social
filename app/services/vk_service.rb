class VkService
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def self.upload_picture(vk_url, img_path)
    file = MimeMagic.by_path("#{ENV['APP_URL']}public#{img_path}")
    
    begin
      VkontakteApi.upload(url: vk_url, photo: [img_path, file.type])
    rescue => e
      Rails.logger.error "Vkontakte image is not uploaded, error: #{e.inspect}"
    end
  end

  def advertise
    puts @credentials

    vk = VkontakteApi::Client.new(@credentials['credentials']['token'])
    vk.wall.post(owner_id: @credentials['uid'], message: "#{@message.message}<br>#{@message.image.url}", attachments: @message.message_link)

    message.redirect_link
  end
end
