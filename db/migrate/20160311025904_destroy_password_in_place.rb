class DestroyPasswordInPlace < ActiveRecord::Migration
  def self.up
    remove_column :places, :enter_by_password
    remove_column :places, :password
  end

  def self.down
    add_column :places, :enter_by_password, :boolean, default: false
    add_column :places, :password, :string, default: '1111'
  end
end
