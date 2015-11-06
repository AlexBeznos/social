class AddBannersToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :city, :string
    add_column :places, :display_my_banners, :boolean, default: false
    add_column :places, :display_other_banners, :boolean, default: false
  end
end
