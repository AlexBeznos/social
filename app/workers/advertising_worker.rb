class AdvertisingWorker
  include Sidekiq::Worker
  include Consumerable

  sidekiq_options queue: :advertisment, retry: false, failures: true

  def perform(place_slug, auth_id, credentials)
    @place       = Place.find_by_slug(place_slug)
    @auth        = Auth.find(auth_id)
    @credentials = credentials

    post_advertisment
  end

  private
  def post_advertisment
    service = "#{@credentials['provider'].capitalize}Service".constantize
    attrs   = {
      place: @place,
      message: @auth.resource,
      credentials: @credentials
    }

    service.new(attrs).advertise
  end
end
