class BackupWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, queue: :backup, failures: true

  def perform
    root_path = "#{Rails.root}/vendor/backup"
    exec("backup perform --trigger gowifi_backup --root-path #{root_path}");
  end
end
