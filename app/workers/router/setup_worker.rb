class Router::SetupWorker
  include Sidekiq::Worker

  sidekiq_options queue: :router_setup, failures: true

  def perform(place_id)
    Router.create!(place_id: place_id)
  end
end
