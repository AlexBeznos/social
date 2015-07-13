class AddReputationToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :reputation_on, :boolean, default: false
    add_column :places, :score_amount, :integer, default: 0
  end
end
