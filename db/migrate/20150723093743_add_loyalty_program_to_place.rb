class AddLoyaltyProgramToPlace < ActiveRecord::Migration
  def change
    add_column :places, :loyalty_program, :boolean, default: false
    add_column :places, :loyalty_program_without_codes, :boolean, default: false
  end
end
