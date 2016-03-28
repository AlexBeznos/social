class MigrateNotifications < ActiveRecord::Migration

  def up
    Auth.all.map(&:approved!)
  end

  def down
    Auth.all.map(&:pending!)
  end
end
