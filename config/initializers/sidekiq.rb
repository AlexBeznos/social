Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}/", namespace: 'sidekiq', network_timeout: 5 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}/", namespace: 'sidekiq', network_timeout: 5 }
end

if Rails.env.production? && !EVN.fetch("STAGE_SERVER", true)
  Sidekiq::Cron::Job.create(name: 'Everyday database backup.', cron: '00 00 * * *', class: 'BackupWorker')
end
