require 'router_settings'
require 'fileless_io'

class WifiRouter::SettingsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :router, failures: true

  def perform(router_id)
    router = Router.find(router_id)
    settings = RouterSettings.new(router)

    settings.copy_files
    settings.replace_config
    settings.archivate

    settings_io = FilelessIO.new(settings.zip)
    settings_io.original_filename = RouterSettings::SETTINGS_FILE

    router.settings = settings_io
    router.save!

    settings.clear!
  end
end
