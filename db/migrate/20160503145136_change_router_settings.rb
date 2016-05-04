class ChangeRouterSettings < ActiveRecord::Migration
  def self.up
    Router.find_each do |router|
      router.reload_settings!
    end
  end

  def self.down
  end
end
