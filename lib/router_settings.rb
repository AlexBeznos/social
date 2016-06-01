require 'fileutils'
require 'zip_archivator'

class RouterSettings
  SETTINGS_FILE = 'settings.zip'
  FILES_TO_COPY = [
    'config.rsc',
    'GoFriends.exe',
    'preconfig.rsc',
    'README.txt'
  ]

  def initialize(router)
    @router = router
    create_settings_folder
  end

  def zip
    path = File.join(settings_path, SETTINGS_FILE)
    File.read(path)
  end

  def copy_files
    login_path = File.join(settings_path, @router.login_page.file.filename)
    File.open(login_path, 'w') { |file| file.write(@router.login_page.read) }

    FILES_TO_COPY.each do |file|
      path = File.join(default_settings_path, file)
      FileUtils.cp(path, settings_path)
    end
  end

  def replace_config
    cmnds = []
    config_path = File.join(settings_path, 'config.rsc')
    mtik_service = MikrotikService.new(@router, 'init_config')

    cmnds += mtik_service.normalized_commands
    #['fetch', 'import', 'remove'].each do |command|
    #  Router::ALLOWED_CRTS.each do |crt|
    #    cmnds.push(send("#{command}_command", crt))
    #  end
    #end

    cmnds.push(ovpn_command)
    File.open(config_path, 'w') { |file| file.write(cmnds.join("\n")) }
  end

  def archivate
    archive_path = File.join(settings_path, SETTINGS_FILE)
    ZipArchivator.new(settings_path, archive_path).write
  end

  def clear!
    FileUtils.rm_rf(settings_path)
  end

  private

  def create_settings_folder
    settings_dir_path = File.join(Rails.root, 'public', 'settings')

    Dir.mkdir(settings_dir_path) unless File.directory?(settings_dir_path)
    FileUtils.rm_rf(settings_path) if File.directory?(settings_path)

    Dir.mkdir(settings_path)
  end

  def settings_path
    File.join(Rails.root, 'public', 'settings', @router.id.to_s)
  end

  def default_settings_path
    File.join(Rails.root, 'vendor', 'router', 'settings')
  end

  def fetch_command(crt)
    "/tool fetch url=http://wifi.gofriends.com.ua/routers/#{@router.access_token}/#{crt} dst-path=#{crt} mode=http\n:delay 5"
  end

  def import_command(crt)
    "/certificate import file-name=#{crt} passphrase=\"\""
  end

  def remove_command(crt)
    "/file remove #{crt}"
  end

  def ovpn_command
    "/interface ovpn-client add name=\"ovpn\" connect-to=#{ENV['OVPN_SERVER']} port=443 user=\"#{@router.place.slug}\" password=\"\" disabled=no profile=default certificate=\"cert_2\" add-default-route=no"
  end
end
