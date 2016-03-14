class RemovePlaceAndPollActive < ActiveRecord::Migration
  def self.up
    remove_column :places, :polls_active
    remove_column :poll_auths, :place_id
  end

  def self.down
    add_column :places, :polls_active, :boolean, default: false
    add_column :poll_auths, :place_id, :integer
  end
end
