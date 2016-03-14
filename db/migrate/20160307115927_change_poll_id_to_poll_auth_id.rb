class ChangePollIdToPollAuthId < ActiveRecord::Migration
  def self.up
    rename_column :answers, :poll_id, :poll_auth_id
  end

  def self.down
    rename_column :answers, :poll_auth_id, :poll_id
  end
end
