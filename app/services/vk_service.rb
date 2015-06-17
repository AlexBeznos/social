require 'open-uri'
class VkService
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def self.upload_picture(vk_url, message)
    file_path = VkService.save_image_localy(message)
    file = MimeMagic.by_path(file_path)

    begin
      VkontakteApi.upload(url: vk_url, photo: [file_path, file.type])
    rescue => e
      Rails.logger.error "Vkontakte image is not uploaded, error: #{e.inspect}"
    end
  end

  def advertise
      albums = vk.photos.getAlbums(owner_id: @credentials['uid'])
      found_album = get_album(albums)

      if found_album == 0
        album_id = vk.photos.createAlbum(title: @place.name)['aid']
      else
        album_id = found_album['aid']
      end

      upload_server = vk.photos.getUploadServer(album_id: album_id)
      hash = VkService.upload_picture(upload_server['upload_url'], @message)
      vk.photos.save(album_id: album_id, server: hash['server'], photos_list: hash['photos_list'], hash: hash['hash'], caption: "#{@message.message} #{@message.message_link}")
  end

  def self.save_image_localy(message)
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

  private
    def image_from_wall
      wall_upload_server = vk.photos.getWallUploadServer(group_id: @credentials['uid'])
      hash = VkService.upload_picture(wall_upload_server['upload_url'], @message)
      photo = vk.photos.saveWallPhoto(
                                      user_id: @credentials['uid'],
                                      group_id: @credentials['uid'],
                                      photo: hash['photo'],
                                      server: hash['server'],
                                      hash: hash['hash']
                                      )

    photo


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

    def vk
      VkontakteApi::Client.new(@credentials['credentials']['token'])
    end
end
