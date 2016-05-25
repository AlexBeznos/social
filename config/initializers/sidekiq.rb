Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}/", namespace: 'sidekiq', network_timeout: 5 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}/", namespace: 'sidekiq', network_timeout: 5 }
end

Sidekiq::Cron::Job.create(name: 'Everyday database backup.', cron: '@daily', class: 'BackupWorker')
