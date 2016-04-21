class Router::SettingsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :router_settings, failures: true

  def perform(router_id)

  end
end
