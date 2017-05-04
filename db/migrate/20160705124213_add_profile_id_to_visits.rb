class AddProfileIdToVisits < ActiveRecord::Migration
  def change
    add_column :customer_visits, :profile_id, :integer
  end
end
