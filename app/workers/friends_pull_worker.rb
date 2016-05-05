class FriendsPullWorker
  include Sidekiq::Worker

  sidekiq_options queue: :advertisment, failures: true

  sidekiq_retry_in do |count|
    10 * (count + 1)
  end

  def perform(klass, id)
    record = klass.constantize.find(id)
    service_class = get_service_klass_by_profile(klass)

    record.update!(friends_count: service_class.get_friends_number(record.access_token))
  end

  private

  def get_service_klass_by_profile(profile_klass)
    network_name = profile_klass.gsub(/Profile/, '')
    "#{network_name}Service".constantize
  end
end
