class WifiSettingsService < ActiveType::Object
  attribute :place_id
  attribute :settings_exist

  validates :place_id, presence: true
  after_validation :get_place

  before_save :check_settings_existence
  before_save :add_settings_files, unless: 'settings_exist'
  before_save :fix_config_file
  before_save :gen_zip_archive
  before_save :post_to_s3_and_update_place
  before_save :delete_folder


  def place_name
    @place.name
  end

  private

    def get_place
      @place = Place.find(place_id)
    end

    def check_settings_existence
      self.settings_exist = get_settings_existence
      puts "Will move settings from default - #{settings_exist}"
    end

    def add_settings_files
      path = "#{Rails.root}/vendor/default_settings/"
      destination = get_path

      FileUtils.mkdir_p(destination) unless File.directory?(destination)

      FileUtils.cp("#{path}config.rsc", destination)
      FileUtils.cp("#{path}plink.exe", destination)
      FileUtils.cp("#{path}psftp.exe", destination)
      FileUtils.cp("#{path}psftp.scr", destination)
      FileUtils.cp("#{path}README.html", destination)
      FileUtils.cp("#{path}start.bat", destination)
      FileUtils.cp("#{path}y.txt", destination)
    end

    def fix_config_file
      config_path = "#{get_path}config.rsc"
      config_text = File.read(config_path)

      config_text.gsub!(/##ssid##/, @place.ssid)
      config_text.gsub!(/##slug##/, @place.slug)
      config_text.gsub!(/##username##/, @place.wifi_username)
      config_text.gsub!(/##password##/, @place.wifi_password)
      config_text.gsub!(/##root##/, @place.domen_url)

      File.open(config_path, "w") {|file| file.puts config_text }
    end

    def gen_zip_archive
      ZipArchivationService.new(get_path, get_archive_path).write
    end

    def post_to_s3_and_update_place
      url = S3UploaderService.upload_zip(get_archive_path)
      @place.update(wifi_settings_link: url)
    end

    def delete_folder
      FileUtils.rm_rf(get_path)
    end

    # utility methods till bottom
    def get_settings_existence
      path = get_path
      config = File.exist?("#{path}config.rsc")
      plink = File.exist?("#{path}plink.exe")
      psftp_exe = File.exist?("#{path}psftp.exe")
      psftp_scr = File.exist?("#{path}psftp.scr")
      readme = File.exist?("#{path}README.html")
      start = File.exist?("#{path}start.bat")
      y = File.exist?("#{path}y.txt")

      config && plink && psftp_exe && psftp_scr && readme && start && y
    end

    def get_path
      "#{Rails.root}/public/settings/#{@place.slug}/"
    end

    def get_archive_path
      "#{get_path}settings.zip"
    end
end
