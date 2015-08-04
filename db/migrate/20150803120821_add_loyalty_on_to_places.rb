class AddLoyaltyOnToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :loyalty_on, :boolean, default: false
  end
end
