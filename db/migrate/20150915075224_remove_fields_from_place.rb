class RemoveFieldsFromPlace < ActiveRecord::Migration
  def self.up
    remove_column :places, :loyalty_on
    remove_column :places, :loyalty_program_without_codes
  end

  def self.down
    add_column :places, :loyalty_on, :boolean, :default => false
    add_column :places, :loyalty_program, :boolean, :default => false
  end
end
