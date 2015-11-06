class AddDomenUrlToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :domen_url, :string, default: "gofriends.com.ua"
  end
end
