class ChangeRouterSettings < ActiveRecord::Migration
  def self.up
    Router.pluck(:id) do |id|
      WifiRouter::SettingsWorker.perform_async(id)
    end
  end

  def self.down
  end
end
