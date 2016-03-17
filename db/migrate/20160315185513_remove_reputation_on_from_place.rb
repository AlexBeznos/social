class RemoveReputationOnFromPlace < ActiveRecord::Migration
  def self.up
    remove_column :places, :reputation_on
  end

  def self.down
    add_column :places, :reputation_on, :boolean, default: false
  end
end
