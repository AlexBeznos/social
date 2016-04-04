class MigrateAuthsState < ActiveRecord::Migration

  def self.up
    Auth.update_all(state: 1)
  end

  def self.down
    Auth.all.map(&:pending!)
  end
end
