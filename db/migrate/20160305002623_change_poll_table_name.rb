class ChangePollTableName < ActiveRecord::Migration
  def self.up
    rename_table :polls, :poll_auths
  end
  
  def self.down
    rename_table :poll_auths, :polls
  end
end
