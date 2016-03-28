class MigrateAuthsState < ActiveRecord::Migration

  def self.up
    Auth.all.map(&:approved!)
  end

  def self.down
    Auth.all.map(&:pending!)
  end
end
