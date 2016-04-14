class RenameVisitsToAhoyVisits < ActiveRecord::Migration
  def change
    rename_table :visits, :ahoy_visits
  end
end
