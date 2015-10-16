class AddPollsActiveToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :polls_active, :boolean, default: false
  end
end
