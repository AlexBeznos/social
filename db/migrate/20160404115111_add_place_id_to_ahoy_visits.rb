class AddPlaceIdToAhoyVisits < ActiveRecord::Migration
  def change
    add_column :ahoy_visits, :place_id, :integer
  end
end
