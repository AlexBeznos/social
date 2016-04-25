class WifiRouter::SetupWorker
  include Sidekiq::Worker

  sidekiq_options queue: :router, failures: true

  def perform(place_id)
    Router.create!(place_id: place_id)
  end
end
