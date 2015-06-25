Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}/12", namespace: 'sidekiq', network_timeout: 5 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}/12", namespace: 'sidekiq', network_timeout: 5 }
end
