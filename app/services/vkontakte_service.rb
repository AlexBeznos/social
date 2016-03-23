require 'open-uri'
class VkontakteService
  include Imagable
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def self.get_token(credentials)
    {
      'provider' => credentials['provider'],
      'token' => credentials['credentials']['token'],
      'uid' => credentials['uid']
    }
  end

  def self.get_friends_number(token)
    vk = VkontakteApi::Client.new(token)
    vk.friends.get(count: 1, v: '5.34')['count']
  end

  def advertise
    vk = vk(@credentials['token'])
    albums = vk.photos.getAlbums(owner_id: @credentials['uid'])
    found_album = get_album(albums)

    album_id = if found_album == 0
      vk.photos.createAlbum(title: @place.name)['aid']
    else
      found_album['aid']
    end

    upload_server = vk.photos.getUploadServer(album_id: album_id)
    hash = upload_picture(upload_server['upload_url'], @message)

    vk.photos.save(
      album_id: album_id,
      server: hash['server'],
      photos_list: hash['photos_list'],
      hash: hash['hash'],
      caption: "#{@message.message} #{@message.message_url}"
    )

    File.delete(@local_path) if File.exist?(@local_path)
  end

  private
  def vk(token)
    VkontakteApi::Client.new(token)
  end

  def upload_picture(vk_url, message)
    file_path = save_image_localy(message)
    file = MimeMagic.by_path(file_path)

    VkontakteApi.upload(url: vk_url, photo: [file_path, file.type])
  end

  def save_image_localy(message)
    img_url     = to_full_url(message.image.url)
    url         = URI.parse(img_url)
    ext         = File.extname(url.path)
    vk_dir      = "#{Rails.root}/public/vk/"
    @local_path = "#{vk_dir}#{message.id}#{ext}"

    FileUtils.mkdir_p(vk_dir) unless File.directory?(vk_dir)
    File.delete(@local_path)  if File.exist?(@local_path)

    open(@local_path, 'wb') do |file|
      file << open(img_url).read
    end

    @local_path
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
