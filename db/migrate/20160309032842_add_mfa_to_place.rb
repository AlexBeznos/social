class AddMfaToPlace < ActiveRecord::Migration
  def change
    add_column :places, :mfa, :boolean, default: false
  end
end
