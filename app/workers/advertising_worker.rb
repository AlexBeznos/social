class AdvertisingWorker
  include Sidekiq::Worker

  sidekiq_options queue: :advertisment, retry: false, failures: true

  def perform(place_slug, auth_id, profile_id)
    @place   = Place.find_by_slug(place_slug)
    @auth    = Auth.find(auth_id)
    @profile = Profile.find(profile_id)

    post_advertisement
  end

  private

  def post_advertisement
    profile_type = @profile.resource_type.downcase.gsub(/profile/, '')
    service = "#{profile_type.capitalize}Service".constantize
    attrs   = {
      place: @place,
      message: @auth.resource,
      profile: @profile.resource
    }

    service.new(attrs).advertise
  end
end
