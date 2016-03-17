class ChangeDefaultForReputation < ActiveRecord::Migration
  def change
    change_column :customer_reputations, :score, :integer, default: 0
  end
end
