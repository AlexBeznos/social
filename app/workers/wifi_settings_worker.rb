class WifiSettingsWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :wifi_settings, :retry => false, :failures => true

  def perform(place_id)
    WifiSettingsService.create(place_id: place_id)
  end
end