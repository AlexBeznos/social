require 'open-uri'
class VkService
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def self.upload_picture(vk_url, message)
    message = Message.find(message.to_i)
    file_path = VkService.save_image_localy(message)
    file = MimeMagic.by_path(file_path)

    begin
      VkontakteApi.upload(url: vk_url, photo: [file_path, file.type])
    rescue => e
      Rails.logger.error "Vkontakte image is not uploaded, error: #{e.inspect}"
    end
  end

  #def advertise
  #  puts @credentials

  #  vk = VkontakteApi::Client.new(@credentials['credentials']['token'])
  #  vk.wall.post(owner_id: @credentials['uid'], message: "#{@message.message}<br>#{@message.image.url}", attachments: @message.message_link)

  #  message.redirect_link
  #end

  def self.save_image_localy(message)
    img_url = message.image.url
    url = URI.parse(img_url)
    ext = File.extname(url.path)
    path = "#{Rails.root}/social/public/vk/#{message.id}#{ext}"

    File.delete(path) if File.exist?(path)

    open(path, 'wb') do |file|
      file << open(img_url).read
    end

    path
  end
end
