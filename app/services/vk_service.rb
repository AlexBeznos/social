require 'open-uri'
class VkService
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def self.get_friends_number(costumer)
    vk = VkontakteApi::Client.new(costumer.access_token)

    begin
      vk.friends.get(count: 1, v: '5.34')['count']
    rescue => e
      Rails.logger.error "Vkontakte friends number error. Error: #{e.inspect}"
      0
    end
  end

  def advertise
    vk = vk(@credentials['credentials']['token'])
    albums = vk.photos.getAlbums(owner_id: @credentials['uid'])
    found_album = get_album(albums)

    begin
      if found_album == 0
        album_id = vk.photos.createAlbum(title: @place.name)['aid']
      else
        album_id = found_album['aid']
      end

      upload_server = vk.photos.getUploadServer(album_id: album_id)
      hash = upload_picture(upload_server['upload_url'], @message)
      vk.photos.save(album_id: album_id, server: hash['server'], photos_list: hash['photos_list'], hash: hash['hash'], caption: "#{@message.message} #{@message.message_link}")
    rescue => e
      Rails.logger.error "Vk Service photo post error: #{e.inspect}"
    end
  end

  private

    def vk(token)
      VkontakteApi::Client.new(token)
    end


    def upload_picture(vk_url, message)
      file_path = save_image_localy(message)
      file = MimeMagic.by_path(file_path)

      begin
        VkontakteApi.upload(url: vk_url, photo: [file_path, file.type])
      rescue => e
        Rails.logger.error "Vkontakte image is not uploaded, error: #{e.inspect}"
      end
    end

    def save_image_localy(message)
      img_url = message.image.url
      url = URI.parse(img_url)
      ext = File.extname(url.path)
      path = "#{Rails.root}/public/vk/#{message.id}#{ext}"

      File.delete(path) if File.exist?(path)

      open(path, 'wb') do |file|
        file << open(img_url).read
      end

      path
    end

    def get_album(albums)
      found_albums = []
      albums.each do |album|
        if album['privacy_view']['type'] == 'all'
          found_albums.push(album)
        end
      end

      found_albums.empty? ? 0 : found_albums.first
    end
end
