class AddAccessCountToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :access_count, :integer, default: 0
    add_column :places, :access_count_day, :integer, default: 0
    add_column :places, :access_count_week, :integer, default: 0
    add_column :places, :access_count_month, :integer, default: 0
  end
end
